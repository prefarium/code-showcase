# frozen_string_literal: true

class Task
  class Create
    include Interactor

    def call
      params = context.task_params

      unless TaskPolicy.can(params[:author]).assign?(params[:assignee])
        context.fail!(error_message: I18n.t('errors.tasks.forbidden_to_assign'), error_status: :forbidden)
      end

      task = context.task = Task.new(params)

      return if task.save

      context.fail!(error_message: error_messages_of(task), error_status: :unprocessable_entity)
    end

    def rollback
      context.task.reload.destroy!
    end
  end
end
