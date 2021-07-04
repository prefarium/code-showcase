# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Bots', type: :request do
  let(:current_user) { create(:telegram_account).user }

  before do
    context = Struct.new('Context', :failure?).new(false)
    allow(TelegramBot::SendMessage).to receive(:call).and_return(context)
  end

  path '/v1/bot/send_invites' do
    post 'рассылка приглашений' do
      tags 'Телеграм-бот'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    link:            { type: :string, description: 'Ссылка на чат в телеге' },
                    user_ids:        { type:        :array,
                                       description: 'ID приглашаемых',
                                       items:       { type: :integer } },
                    birthday_man_id: { type: :integer, description: 'ID именинника' }
                  },
                  required:   %i[link user_ids birthday_man_id]
                }

      authorize!

      let(:params) { { link: 't.me/joinchat/abba', user_ids: [current_user.id] } }

      context 'когда есть права на рассылку' do
        response '204', 'отправлены' do
          before do
            policy = instance_double(BotPolicy, invite?: true)
            allow(BotPolicy).to receive(:can).and_return(policy)
          end

          run_test!
        end
      end

      context 'когда нет прав на рассылку' do
        response '403', 'недостаточно прав' do
          before do
            policy = instance_double(BotPolicy, invite?: false)
            allow(BotPolicy).to receive(:can).and_return(policy)
          end

          run_test!
        end
      end
    end
  end
end
