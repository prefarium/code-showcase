# frozen_string_literal: true

module V1
  module Current
    class PasswordsController < APIController
      def update
        context = User::Update.call(user:        current_user,
                                    user_params: { password: params[:password] })

        render_error_from_context(context) if context.failure?
      end
    end
  end
end
