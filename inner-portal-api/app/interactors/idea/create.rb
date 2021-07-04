# frozen_string_literal: true

class Idea
  class Create
    include Interactor

    def call
      params = context.idea_params
      params[:division] ||= params[:author].division

      idea = context.idea = Idea.new(params)

      return if idea.save

      context.fail!(error_message: error_messages_of(idea), error_status: :unprocessable_entity)
    end

    def rollback
      context.idea.reload.destroy!
    end
  end
end
