# frozen_string_literal: true

class Idea
  class DeletePins
    include Interactor

    def call
      idea              = context.idea
      context.idea_pins = idea.pins.to_a

      context.fail!(error_message: I18n.t('errors.pins.failed_to_unpin')) unless idea.pins.destroy_all
    end

    def rollback
      context.idea_pins.each { |pin| pin.dup.save! }
    end
  end
end
