# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Компетенции', type: :request do
  path '/landing/competences' do
    get 'список компетенций' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      paginable!

      response '200', 'массив с компетенциями' do
        run_test!
      end
    end
  end
end
