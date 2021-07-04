# frozen_string_literal: true

module V1
  class FeedbacksController < APIController
    def create
      context = Feedback::New.call(file:            params[:file],
                                   feedback_params: { body: params[:body], author_id: current_user.id })

      render_error_from_context(context) if context.failure?
    end
  end
end
