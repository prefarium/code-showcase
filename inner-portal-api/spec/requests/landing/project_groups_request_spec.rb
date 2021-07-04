# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Project groups', type: :request do
  path '/landing/project_groups' do
    get 'список групп проектов' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'группы' do
        run_test!
      end
    end
  end

  path '/landing/project_groups/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID группы проектов'

    get 'конкретная группа' do
      tags 'Лэндинг'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'проект' do
        run_test!
      end
    end
  end
end
