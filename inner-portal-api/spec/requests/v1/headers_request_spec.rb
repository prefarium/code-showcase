# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Запросы для хэдера', type: :request do
  let(:current_user) { create(:user) }

  path '/v1/header/notification_numbers' do
    get 'цифры для хэдера' do
      tags 'Текущий пользователь'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :number_of_days,
                in:          :query,
                type:        :integer,
                default:     7,
                required:    false,
                description: 'Количество ближайших дней, за которые требуется учесть дни рождения'

      authorize!

      response '200', 'цифры для хэдера' do
        run_test! { expect(response_json).not_to be_empty }
      end
    end
  end
end
