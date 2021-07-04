# frozen_string_literal: true

require 'swagger_helper'

describe 'Users', type: :request do
  let(:current_user) { create(:user) }

  path '/v1/current/user' do
    get 'получение информации о текущем пользователе' do
      tags 'Текущий пользователь'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      response '200', 'инфа подъехала' do
        run_test! { expect(response_json).not_to be_empty }
      end
    end
  end
end
