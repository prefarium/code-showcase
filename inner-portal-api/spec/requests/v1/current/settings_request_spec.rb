# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Settings', type: :request do
  let(:current_user) { create(:user) }

  before do
    context     = Struct.new('Context', :failure?).new(false)
    interactors = [
      User::Update,
      NotificationSetting::Update,
      TelegramAccount::Create,
      TelegramAccount::Update,
      TelegramAccount::Destroy
    ]

    interactors.each { |interactor| allow(interactor).to receive(:call).and_return(context) }
  end

  path '/v1/current/settings' do
    put 'обновление настроек' do
      tags 'Текущий пользователь'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    user:                 {
                      type:       :object,
                      properties: {
                        email:           { type: :string, description: 'Электронная почта' },
                        phone:           { type: :string, description: 'Номер телефона' },
                        actual_position: { type: :string, description: 'Фактическая должность' },
                        telegram:        { type: :string, description: 'Имя пользователя в телеге' }
                      }
                    },
                    notification_setting: {
                      type:       :object,
                      properties: {
                        email:   { type: :boolean, description: 'Получать ли уведомления на почту' },
                        browser: { type: :boolean, description: 'Получать ли уведомления в браузере' }
                      }
                    }
                  }
                }

      authorize!

      response '204', 'обновлено' do
        let(:params) { {} }

        run_test!
      end
    end
  end
end
