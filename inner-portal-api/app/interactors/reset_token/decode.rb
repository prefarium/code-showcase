# frozen_string_literal: true

module ResetToken
  class Decode
    include Interactor

    def call
      token    = context.token
      password = context.password

      begin
        parsed_token = JWTSessions::Token.decode(token).first
      rescue JWTSessions::Errors::Expired
        context.fail!(error_message: I18n.t('errors.authentication.link_expired'), error_status: :forbidden)
      end

      user = User.find(parsed_token['user_id'])

      if user.reset_token != token
        context.fail!(error_message: I18n.t('errors.authentication.incorrect_reset_token'),
                      error_status:  :unprocessable_entity)
      end

      context.user        = user
      context.user_params = { password: password, reset_token: nil }
    end
  end
end
