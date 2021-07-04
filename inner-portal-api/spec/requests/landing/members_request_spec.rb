# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Члены команда', type: :request do
  path '/landing/members' do
    get 'список членов команды' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'массив людей' do
        run_test!
      end
    end
  end
end
