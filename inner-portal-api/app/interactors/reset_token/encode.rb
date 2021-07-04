# frozen_string_literal: true

module ResetToken
  class Encode
    include Interactor

    def call
      user        = context.user
      user_params = context.user_params
      exp_time    = context.exp_time

      payload = { user_id: user.id, exp: (Time.current + exp_time).to_i }
      token   = JWTSessions::Token.encode(payload)

      context.token       = token
      context.user_params = user_params.present? ? user_params.merge(reset_token: token) : { reset_token: token }
    end
  end
end
