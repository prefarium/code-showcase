# frozen_string_literal: true

class Event
  class Destroy
    include Interactor

    def call
      event                      = context.event
      context.event_participants = User.where(id: event.participant_ids)

      return if event.destroy

      context.fail!(error_message: error_messages_of(event), error_status: :unprocessable_entity)
    end

    def rollback
      context.event.restore
    end
  end
end
