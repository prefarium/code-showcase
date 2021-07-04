# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Calendar', type: :request do
  let(:current_user) { create(:user) }

  path '/v1/calendar' do
    get 'календарь' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :user_id,
                in:          :query,
                type:        :integer,
                required:    false,
                description: 'ID пользователя, чьи события требуется вернуть. ' \
                             'Если не передано, используется ID текущего пользователя'

      parameter name:        :for_division,
                in:          :query,
                type:        :boolean,
                default:     false,
                required:    false,
                description: 'Требуется ли вернуть события всех работников подразделения'

      parameter name:        :filter,
                in:          :query,
                type:        :string,
                default:     :all,
                required:    false,
                examples:    {
                  assigned: { summary: 'является участником', value: :assigned },
                  created:  { summary: 'является автором', value: :created },
                  all:      { summary: 'является или тем, или другим', value: :all }
                },
                description: 'Тип связи пользователя и событий'

      parameter name:        :common,
                in:          :query,
                type:        :boolean,
                default:     true,
                required:    false,
                description: 'Требуется ли включить в ответ общие события'

      parameter name:        :month,
                in:          :query,
                type:        :integer,
                required:    false,
                description: 'Месяц на календаре. Если не передан, используется текущий'

      parameter name:        :year,
                in:          :query,
                type:        :integer,
                required:    false,
                description: 'Год на календаре. Если не передан, используется текущий'

      authorize!

      context 'когда есть права на просмотр' do
        before do
          policy  = instance_double(EventPolicy, access?: true, use_params?: true)
          context = Struct.new('Context', :calendar).new({})

          allow(EventPolicy).to receive(:can).and_return(policy)
          allow(Events::CollectionForCalendarQuery).to receive(:call).and_return(nil)
          allow(Calendar::Fill).to receive(:call).and_return(context)
        end

        response '200', 'календарь' do
          run_test! { expect(response_json).to be_kind_of Hash }
        end
      end

      context 'когда нет прав на просмотр календаря пользователя' do
        before do
          policy = instance_double(EventPolicy, access?: false)

          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '200', 'флаг __FORBIDDEN__' do
          run_test! { expect(response_json).to eq '__FORBIDDEN__' }
        end
      end

      context 'когда нет прав на использование переданных параметров' do
        before do
          policy = instance_double(EventPolicy, access?: true, use_params?: false)

          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'запрещено использовать переданные параметры' do
          run_test!
        end
      end
    end
  end
end
