# frozen_string_literal: true

require 'swagger_helper'

describe 'Сброс пароля' do
  let(:user)    { create(:dashboard).user                                  }
  let(:context) { Struct.new('Context', :failure?, :user).new(false, user) }

  before do
    allow(User::Password::RequestResetLink).to receive(:call).and_return(context)
    allow(User::Password::Reset).to receive(:call).and_return(context)
  end

  path '/v1/password/new' do
    get 'сброс пароля' do
      tags 'Аутентификация'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :email,
                in:          :query,
                type:        :string,
                required:    true,
                description: 'Email'

      response '204', 'отправлено письмо для восстановления' do
        let(:email) { user.email }

        run_test!
      end
    end
  end

  path '/v1/password' do
    post 'установка нового пароля' do
      tags 'Аутентификация'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    token:    { type: :string, description: 'Токен для сброса пароля' },
                    password: { type: :string, description: 'Пароль' }
                  },
                  required:   %w[token password]
                }

      response '200', 'пароль изменён' do
        let(:params) { { token: 'token', password: 'qwerty123' } }

        run_test! do
          expect(response_json[:access]).to be_present
          expect(response_json[:refresh]).to be_present
        end
      end
    end
  end
end
