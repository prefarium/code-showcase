# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Карточки для хэдера', type: :request do
  path '/landing/header_cards' do
    get 'список карточек для хэдера' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'массив карточек' do
        run_test!
      end
    end
  end
end
