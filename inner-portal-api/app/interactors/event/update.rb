# frozen_string_literal: true

class Event
  class Update
    include Interactor

    def call
      event  = context.event
      params = context.event_params

      if params[:status].present? && !event.confirmable?
        context.fail!(error_message: I18n.t('errors.events.not_updatable_status'), error_status: :unprocessable_entity)

      elsif params[:status].present? && event.confirmable? && event.status != 'pending'
        context.fail!(error_message: I18n.t('errors.events.status_already_changed'),
                      error_status:  :unprocessable_entity)
      end

      context.event_attributes_backup = event.attributes

      return if event.update(params)

      context.fail!(error_message: error_messages_of(event), error_status: :unprocessable_entity)
    end

    def rollback
      context.event.reload.update!(context.event_attributes_backup)
    end
  end
end
