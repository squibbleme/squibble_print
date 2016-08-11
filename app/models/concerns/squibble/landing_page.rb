# Dieses Modul erlaubt die standartisierte Verwaltung von Attributen,
# die für die optimale Darstellung einer Landing Page benötigt werden.
#
# Über den folgenden include im Model ist dies möglich:
#
# [...]
# include Squibble::LandingPage
# [...]
#
module Squibble::LandingPage
  extend ActiveSupport::Concern

  included do
    # Ablage des Einführungstextes für Call To Action
    #
    field :call_to_action_introduction,
          type: String,
          localize: true

    # Ablage des Call To Action Textes
    #
    field :call_to_action_text,
          type: String,
          localize: true

    # Ablage des Links für die Call To Action
    #
    field :call_to_action_link,
          type: String,
          localize: true

    # Ablage ob es sich bei der Call To Action um einen
    # dynamischen Link handelt oder nicht. Ist :call_to_action_link_dynamic
    # aktiviert, so wird der Link per eval() ausgegeben.
    #
    field :call_to_action_link_dynamic,
          type: Boolean,
          default: true

    #  Ablage der Headline. Dieses Attribut wird normalerweise
    # als Überschrift für die Seite / als Titel verwendet.
    #
    field :headline,
          type: String,
          localize: true
    validates :headline,
              length: {
                maximum: 200
              },
              allow_blank: true,
              allow_nil: true

    # Ablage der Einleitung. Dieses Attribut wird als Einleitung
    # für die Seite verwendet. Das Attribut sollte normalen Text beinhalten
    # und nicht über HTML Markup verwendet werden.
    #
    field :introduction,
          type: String,
          localize: true
    validates :introduction,
              length: {
                maximum: 800
              },
              allow_blank: true,
              allow_nil: true

    # Ablage des :why_reasons (Verkaufsargumente).
    # Wieso handelt es sich bei dem Produkt um das Richtige für den Kunden?
    # Gründe / Argumente für seine Entscheidung!
    #
    embeds_many :why_reasons,
                class_name: 'KeyValue',
                order: :sort.asc,
                inverse_of: nil
    accepts_nested_attributes_for :why_reasons,
                                  allow_destroy: true

    #  Ablage der Subline. Dieses Attribut wird normalerweise
    # als Überschrift für die Seite / als Titel verwendet.
    #
    field :subline,
          type: String,
          localize: true
    validates :subline,
              length: {
                maximum: 400
              },
              allow_blank: true,
              allow_nil: true

    # Ablage des :unique_value_proposition (Nutzenversprechen / Alleinstellungsmerkmale).
    # Idealerweise werden hierbei zwischen 5 und 7 der wichtigsten Nutzen
    # abgelegt.
    #
    embeds_many :unique_value_propositions,
                class_name: 'KeyValue',
                order: :sort.asc,
                inverse_of: nil
    accepts_nested_attributes_for :unique_value_propositions,
                                  allow_destroy: true
  end
end
