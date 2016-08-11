module SearchableModel
  extend ActiveSupport::Concern

  included do
    include ::Elasticsearch::Model

    mapping do
      # ...
    end

    # Temporärer Fix, damit für erbende Klassen der StackLevel ToDeep Error nicht
    # geworfen wird.
    # gem. https://github.com/elastic/elasticsearch-rails/issues/144
    #
    def self.inherited(child)
      super

      child.instance_eval do
        include ::Elasticsearch::Model
      end
    end

    # index document on model touch
    # @see: http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
    # after_touch() { __elasticsearch__.index_document }

    # def self.search(query)
    ##
    # end

    def resource_class
      self.class.to_s
    end

    def as_indexed_json(_options = {})
      as_json(
        methods: :resource_class,
        except: default_json_excepts.push(custom_json_excepts).flatten.uniq,
        include: custom_json_includes
      )
    rescue NoMethodError => e
      Rails.logger.error "Unable to execute :as_indexed_json: #{e.message}"
    end

    def default_json_excepts
      [:id, :_id, :version, :versions, :created_at, :updated_at]
    end

    def custom_json_excepts
    end

    def custom_json_includes
    end

    scope :simple_query, lambda { |query, filter_terms = nil|
      response = if filter_terms.nil?
                   search(query)
                 else
                   search(
                     query: { match: { _all: query } },
                     filter: { term: filter_terms }
                   )
                 end
      response.records
    }

  end

  def self.included(base)
    base.after_touch   { |document| Elasticsearch::IndexerWorker.perform_async(:touch, document.class, :index, document.id) }
    base.after_create  { |document| Elasticsearch::IndexerWorker.perform_async(:create, document.class, :index, document.id) }
    base.after_update  { |document| Elasticsearch::IndexerWorker.perform_async(:update, document.class, :update, document.id) }
    base.after_destroy { |document| Elasticsearch::IndexerWorker.perform_async(:destroy, document.class, :destroy, document.id) }
  end
end
