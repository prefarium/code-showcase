# frozen_string_literal: true

JWTSessions.token_store = if Rails.env.test?
                            :memory
                          else
                            [
                              :redis,
                              {
                                redis_url:    'redis://localhost:6379/0',
                                token_prefix: 'jwt_'
                              }
                            ]
                          end

JWTSessions.encryption_key   = Rails.application.secret_key_base
JWTSessions.access_exp_time  = 1.day.to_i
JWTSessions.refresh_exp_time = 1.month.to_i
