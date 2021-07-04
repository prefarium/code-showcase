# frozen_string_literal: true

class User
  class Create
    include Interactor

    def call
      user_params            = context.user_params
      user_params[:password] = SecureRandom.hex if user_params[:password].blank?
      user                   = context.user = User.new(user_params)

      return if user.save

      context.fail!(error_message: error_messages_of(user), error_status: :unprocessable_entity)
    end

    def rollback
      context.user.reload.destroy!
    end
  end
end
