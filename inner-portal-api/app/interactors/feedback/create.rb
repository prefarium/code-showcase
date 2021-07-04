# frozen_string_literal: true

class Feedback
  class Create
    include Interactor

    def call
      params   = context.feedback_params
      feedback = context.feedback = Feedback.new(params)

      return if feedback.save

      context.fail!(error_message: error_messages_of(feedback), error_status: :unprocessable_entity)
    end

    def rollback
      context.feedback.reload.destroy!
    end
  end
end
