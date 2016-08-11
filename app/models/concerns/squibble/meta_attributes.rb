# Dieses Modul kümmert sich darum, dass die Meta Attribute
# für eine Klasse standartisiert abgelegt werden können.
#
# Über den folgenden include im Model ist dies möglich:
#
# [...]
# include Squibble::MetaAttributes
# [...]
#
module Squibble::MetaAttributes
  extend ActiveSupport::Concern

  included do
    field :meta_description,
          type: String
    validates :meta_description,
              length: {
                maximum: 155
              }

    field :meta_keywords,
          type: Array,
          default: []

    def meta_keywords=(meta_keywords)
      if meta_keywords.is_a?(Array) && meta_keywords.length == 1
        meta_keywords = meta_keywords.first
      end

      meta_keywords = meta_keywords.split(',') if meta_keywords.is_a? String
      self[:meta_keywords] = meta_keywords.flatten.uniq.map(&:squish!)
    end
  end
end
