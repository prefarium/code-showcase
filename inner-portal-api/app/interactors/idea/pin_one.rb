# frozen_string_literal: true

class Idea
  class PinOne
    include Interactor

    def call
      idea   = context.idea
      pinner = context.pinner

      if Pin.find_by(idea: idea, pinner: pinner)
        context.fail!(error_message: I18n.t('errors.ideas.already_pinned'), error_status: :forbidden)
      end

      pin = context.pin = Pin.new(idea: idea, pinner: pinner)

      return if pin.save

      context.fail!(error_message: error_messages_of(pin), error_status: :unprocessable_entity)
    end

    def rollback
      context.pin.reload.destroy!
    end
  end
end
