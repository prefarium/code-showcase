# frozen_string_literal: true

require 'swagger_helper'

describe 'Passwords', type: :request do
  let(:current_user) { create(:user) }

  before do
    context = Struct.new('Context', :failure?).new(false)
    allow(User::Update).to receive(:call).and_return(context)
  end

  path '/v1/current/password' do
    put 'изменение пароля' do
      tags 'Текущий пользователь'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    password: { type: :string, description: 'Пароль' }
                  },
                  required:   %w[password]
                }

      authorize!

      response '204', 'изменён' do
        let(:params) { { password: '' } }

        run_test!
      end
    end
  end
end
