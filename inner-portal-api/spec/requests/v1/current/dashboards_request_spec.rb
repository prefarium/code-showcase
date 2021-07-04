# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Dashboards', type: :request do
  let(:dashboard)    { create(:dashboard) }
  let(:current_user) { dashboard.user     }

  before do
    context = Struct.new('Context', :failure?).new(false)
    allow(Dashboard::Update).to receive(:call).and_return(context)
  end

  path '/v1/current/dashboard' do
    get 'текущие настройки дэшборда' do
      tags 'Текущий пользователь'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      response '200', 'список настроек' do
        run_test! { expect(response_json).not_to be_empty }
      end
    end

    put 'обновление настроек дэшборда' do
      tags 'Текущий пользователь'
      consumes 'application/json'
      produces 'application/json'

      parameter in:       :query,
                name:     :tasks,
                type:     :boolean,
                required: false

      parameter in:       :query,
                name:     :events,
                type:     :boolean,
                required: false

      parameter in:       :query,
                name:     :birthdays,
                type:     :boolean,
                required: false

      parameter in:       :query,
                name:     :news,
                type:     :boolean,
                required: false

      parameter in:       :query,
                name:     :today,
                type:     :boolean,
                required: false

      parameter in:       :query,
                name:     :ideas,
                type:     :boolean,
                required: false

      parameter in:       :query,
                name:     :petitions,
                type:     :boolean,
                required: false

      parameter in:       :query,
                name:     :documents,
                type:     :boolean,
                required: false

      authorize!

      response '204', 'обновлено' do
        run_test!
      end
    end
  end
end
