# frozen_string_literal: true

module V1
  module Authentication
    class SessionsController < APIController
      skip_before_action :authorize_by_access_header!
      before_action :authorize_by_refresh_header!, only: :destroy

      def create
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          render json: SessionGenerator.new(user).login_with_cache
        else
          render_error(I18n.t('errors.authentication.incorrect_credentials'), :unauthorized)
        end
      end

      def destroy
        session = JWTSessions::Session.new
        session.flush_by_uid(payload['uid'])
      end
    end
  end
end
