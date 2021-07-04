# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Новости', type: :request do
  path '/landing/news' do
    get 'список новостей' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      paginable!

      response '200', 'массив новостей' do
        run_test!
      end
    end
  end
end
