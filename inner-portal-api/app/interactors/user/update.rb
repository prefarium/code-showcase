# frozen_string_literal: true

class User
  class Update
    include Interactor

    def call
      user   = context.user
      params = context.user_params

      context.user_attributes_backup = user.attributes

      return if user.update(params)

      context.fail!(error_message: error_messages_of(user), status: :unprocessable_entity)
    end

    def rollback
      context.user.reload.update!(context.user_attributes_backup)
    end
  end
end
