# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Исторические отметки', type: :request do
  path '/landing/history_marks' do
    get 'список исторических отметок' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'массив с отметками' do
        run_test!
      end
    end
  end
end
