# frozen_string_literal: true

class Idea
  class Unpin
    include Interactor

    def call
      idea   = context.idea
      pinner = context.pinner
      pin    = context.pin = Pin.find_by(idea: idea, pinner: pinner)

      context.fail!(error_message: I18n.t('errors.ideas.not_pinned'), error_status: :unprocessable_entity) unless pin

      return if pin.destroy

      context.fail!(error_message: error_messages_of(pin), error_status: :unprocessable_entity)
    end

    def rollback
      context.pin = context.pin.dup
      context.pin.save!
    end
  end
end
