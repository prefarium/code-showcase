# frozen_string_literal: true

module V1
  module Authentication
    class PasswordsController < APIController
      skip_before_action :authorize_by_access_header!

      def new
        user = User.find_by(email: params[:email])

        return render_error(I18n.t('errors.authentication.user_not_found'), :not_found) if user.blank?

        context = User::Password::RequestResetLink.call(user: user, exp_time: 2.hours)

        render_error_from_context(context) if context.failure?
      end

      def create
        context = User::Password::Reset.call(token: params[:token], password: params[:password])

        return render_error_from_context(context) if context.failure?

        render json: SessionGenerator.new(context.user).login_with_cache
      end
    end
  end
end
