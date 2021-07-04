# frozen_string_literal: true

class Task
  class Destroy
    include Interactor

    def call
      task = context.task

      return if task.destroy

      context.fail!(error_message: error_messages_of(task), error_status: :unprocessable_entity)
    end

    def rollback
      context.task.restore
    end
  end
end
