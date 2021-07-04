# frozen_string_literal: true

class Idea
  class Update
    include Interactor

    def call
      idea   = context.idea
      params = context.idea_params

      context.idea_attributes_backup = idea.attributes

      return if idea.update(params)

      context.fail!(error_message: error_messages_of(idea), error_status: :unprocessable_entity)
    end

    def rollback
      context.idea.update!(context.idea_attributes_backup)
    end
  end
end
