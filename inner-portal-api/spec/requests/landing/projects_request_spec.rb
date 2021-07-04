# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Проекты', type: :request do
  path '/landing/projects' do
    get 'список проектов' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :show_on_root,
                in:          :query,
                type:        :boolean,
                required:    false,
                description: 'Нужно ли вернуть только те проекты, которые должны отображаться на главной'

      response '200', 'массив проектов' do
        run_test!
      end
    end
  end

  path '/landing/projects/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID проекта'

    get 'конкретный проект' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'проект' do
        run_test!
      end
    end
  end
end
