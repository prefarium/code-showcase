# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Тексты для различных разделов', type: :request do
  path '/landing/texts' do
    get 'тексты для разных разделов' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'объект с текстами' do
        run_test!
      end
    end
  end
end
