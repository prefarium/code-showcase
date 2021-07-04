# frozen_string_literal: true

require 'swagger_helper'

describe 'Обновление access-токена' do
  let(:user) { create(:user) }

  path '/v1/refresh' do
    post 'обновление access-токена' do
      tags 'Аутентификация'
      consumes 'application/json'
      produces 'application/json'
      security [Refresh: []]

      response '200', 'access-токен обновлён' do
        let(:tokens) { tokens_for(user) }
        let('X-Refresh-Token') { tokens[:refresh] }

        run_test! do
          expect(response_json[:access]).not_to be_empty
          expect(response_json[:access]).not_to eq(tokens[:access])
        end
      end
    end
  end
end
