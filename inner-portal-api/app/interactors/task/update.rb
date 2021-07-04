# frozen_string_literal: true

class Task
  class Update
    include Interactor

    def call
      params = context.task_params
      task   = context.task

      if params[:status] == 'assigned'
        context.fail!(error_message: I18n.t('errors.tasks.assigned_status_not_allowed'),
                      error_status:  :unprocessable_entity)
      end

      context.task_attributes_backup = task.attributes

      return if task.update(params)

      context.fail!(error_message: error_messages_of(task), error_status: :unprocessable_entity)
    end

    def rollback
      context.task.update!(context.task_attributes_backup)
    end
  end
end
