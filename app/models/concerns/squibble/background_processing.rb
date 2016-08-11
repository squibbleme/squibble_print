# Dieses Modul erlaubt die Überwachung über die Hintergrundverarbeitung
# eines Datensatzes.
#
# Über den folgenden include im Model ist dies möglich:
#
# [...]
# include Squibble::BackgroundProcessing
# [...]
#
# Über die Methode resource.can_start_background_processing? kann geprüft
# werden, ob eine entsprechende Verarbeitung aktuell zulässig ist oder ob
# bereits eine Verarbeitung im Hintergrund läuft.
#
module Squibble::BackgroundProcessing
  extend ActiveSupport::Concern

  included do
    field :perform_async,
          type: Boolean,
          default: true

    state_machine :async_background_processing, initial: :background_processing_init do
      # state :background_processing_init do
      # end
      # state :background_processing_in_progress do
      # end
      # state :background_processing_succeeded do
      # end
      # state :background_processing_halted do
      # end
      # state :background_processing_failed do
      # end

      event :start_background_processing do
        transition [:background_processing_init, :background_processing_succeeded, :background_processing_halted, :background_processing_failed] => :background_processing_in_progress
      end

      event :succeed_completed_background_processing do
        transition background_processing_in_progress: :background_processing_succeeded
      end

      event :fail_background_processing do
        transition background_processing_in_progress: :background_processing_failed
      end

      event :halt_background_processing do
        transition background_processing_in_progress: :background_processing_halted
      end
    end

    def async_background_processing_translation_key
      "async_background_processing_#{async_background_processing}"
    end

    def async_background_processing_translated
      self.class.human_attribute_name(async_background_processing_translation_key)
    end
  end
end
