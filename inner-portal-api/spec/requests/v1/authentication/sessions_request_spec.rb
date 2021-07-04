# frozen_string_literal: true

require 'swagger_helper'

describe 'Сессия' do
  let(:user) { create(:dashboard).user }

  path '/v1/login' do
    post 'аутентификация' do
      tags 'Аутентификация'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    email:    { type: :string, description: 'Email' },
                    password: { type: :string, description: 'Пароль' }
                  },
                  required:   %w[email password]
                }

      response '200', 'авторизован' do
        let(:params) { { email: user.email, password: 'password' } }

        run_test! do
          expect(response_json[:access]).not_to be_empty
          expect(response_json[:refresh]).not_to be_empty
        end
      end

      response '401', 'неверный логин или пароль' do
        let(:params) { { email: user.email, password: 'qwerty123' } }

        run_test!
      end
    end
  end

  path '/v1/logout' do
    delete 'выход из лк' do
      tags 'Аутентификация'
      consumes 'application/json'
      produces 'application/json'
      security [Refresh: []]

      response '204', 'разлогинен' do
        let(:tokens)           { tokens_for(user) }
        let('X-Refresh-Token') { tokens[:refresh] }

        run_test! do
          session_existence = JWTSessions::Session.new.session_exists?(tokens[:access], 'access')
          expect(session_existence).to be_falsey
        end
      end
    end
  end
end
