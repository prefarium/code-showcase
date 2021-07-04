# frozen_string_literal: true

class Event
  class Create
    include Interactor

    def call
      params = context.event_params
      event  = context.event = Event.new(params)

      if event.confirmable?
        event.status       = :pending
        event.participants = [event.author]
      end

      define_participants if !event.confirmable? && !event.common?

      return if event.save

      context.fail!(error_message: error_messages_of(event), error_status: :unprocessable_entity)
    end

    def rollback
      context.event.reload.destroy!
    end

    private

    def define_participants
      event           = context.event
      for_division    = context.for_division
      participant_ids = context.participant_ids

      if for_division && participant_ids.present?
        context.fail!(error_message: I18n.t('errors.events.division_and_participants_incompatible'),
                      error_status:  :unprocessable_entity)

      elsif !for_division && participant_ids.blank?
        context.fail!(error_message: I18n.t('errors.events.missing_participants'),
                      error_status:  :unprocessable_entity)

      elsif for_division
        unless EventPolicy.can(event.author).assign_division?
          context.fail!(error_message: I18n.t('errors.events.forbidden_audience'), error_status: :forbidden)
        end

        participant_ids = User.where(division_id: event.author.division_id)
                              .and(User.where.not(id: event.author.id))
                              .ids

      else
        unless EventPolicy.can(event.author).assign_users?(participant_ids)
          context.fail!(error_message: I18n.t('errors.events.forbidden_audience'), error_status: :forbidden)
        end
      end

      event.participant_ids = participant_ids
    end
  end
end
