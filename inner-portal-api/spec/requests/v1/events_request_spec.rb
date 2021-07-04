# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Events', type: :request do
  let(:current_user) { create(:user) }
  let(:second_user)  { create(:user) }

  before do
    create_list(:event, 2, :confirmable, author: current_user, status: :pending)

    context = Struct.new('Context', :failure?).new(false)

    allow(Event::Assign).to receive(:call).and_return(context)
    allow(Event::ChangeStatus).to receive(:call).and_return(context)
    allow(Event::Cancel).to receive(:call).and_return(context)
    allow(Event::Update).to receive(:call).and_return(context)
  end

  path '/v1/events' do
    get 'список событий' do
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

      parameter name:        :date,
                in:          :query,
                type:        :string,
                format:      :date,
                required:    false,
                description: 'Дата, за которую нужно вернуть события. Если не передана, используется текущая'

      paginable!
      searchable!
      authorize!

      response '200', 'список событий' do
        context 'когда есть права на просмотр' do
          before do
            policy = instance_double(EventPolicy, access?: true)

            allow(EventPolicy).to receive(:can).and_return(policy)
            allow(Events::FilteredCollectionQuery).to receive(:call).and_return(Event.none)
          end

          run_test! { expect(response_json).to be_kind_of Hash }
        end

        context 'когда нет прав на просмотр событий пользователя' do
          before do
            policy = instance_double(EventPolicy, access?: false)
            allow(EventPolicy).to receive(:can).and_return(policy)
          end

          run_test! { expect(response_json).to eq resources: '__FORBIDDEN__' }
        end
      end
    end

    post 'создание' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  oneOf: [
                    {
                      type:       :object,
                      properties: {
                        confirmable: { type:        :boolean,
                                       description: 'Требуется ли согласование. Только true',
                                       default:     true },
                        type:        { type:        :string,
                                       description: 'Тип. Эндпоинт с вариантами лежит в селекторах' },
                        description: { type: :string, description: 'Описание' },
                        start_time:  { type: :string, description: 'Время начала', format: 'date-time' },
                        end_time:    { type: :string, description: 'Время окончания', format: 'date-time' }
                      },
                      required:   %w[confirmable type start_time end_time]
                    },
                    {
                      type:       :object,
                      properties: {
                        confirmable:  { type:        :boolean,
                                        description: 'Требуется ли согласование. Только false',
                                        default:     false },
                        title:        { type: :string, description: 'Заголовок' },
                        description:  { type: :string, description: 'Описание' },
                        start_time:   { type: :string, description: 'Время начала', format: 'date-time' },
                        end_time:     { type: :string, description: 'Время окончания', format: 'date-time' },
                        for_division: { type:        :integer,
                                        description: 'Флаг, что событие нужно создать для всего подразделения' }
                      },
                      required:   %w[confirmable title start_time end_time for_division]
                    },
                    {
                      type:       :object,
                      properties: {
                        confirmable:     { type:        :boolean,
                                           description: 'Требуется ли согласование. Только false',
                                           default:     false },
                        title:           { type: :string, description: 'Заголовок' },
                        description:     { type: :string, description: 'Описание' },
                        start_time:      { type: :string, description: 'Время начала', format: 'date-time' },
                        end_time:        { type: :string, description: 'Время окончания', format: 'date-time' },
                        participant_ids: { type:        :array,
                                           description: 'ID участников',
                                           items:       { type: :integer } }
                      },
                      required:   %w[confirmable title start_time end_time participant_ids]
                    }
                  ]
                }

      authorize!

      describe 'confirmable' do
        response '204', 'создано' do
          let(:params) { { confirmable: '', start_time: '', end_time: '', type: '' } }

          run_test!
        end
      end

      describe 'not confirmable' do
        response '204', 'создано' do
          let(:params) { { confirmable: '', start_time: '', end_time: '', title: '', participant_ids: [1] } }

          run_test!
        end
      end
    end
  end

  path '/v1/events/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID'

    get 'просмотр' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { current_user.events.first.id }

      context 'когда есть права на просмотр' do
        before do
          policy = instance_double(EventPolicy, read?: true)
          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '200', 'событие' do
          run_test! { expect(response_json).not_to be_empty }
        end
      end

      context 'когда нет прав на просмотр' do
        before do
          policy = instance_double(EventPolicy, read?: false)
          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end

    put 'редактирование' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    title:       { type: :string, description: 'Заголовок' },
                    description: { type: :string, description: 'Описание' }
                  }
                }

      authorize!

      let(:id)     { current_user.events.first.id }
      let(:params) { { status: :approved }        }

      context 'когда есть права на обновление' do
        before do
          policy = instance_double(EventPolicy, edit?: true)
          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'обновлён' do
          run_test!
        end
      end

      context 'когда нет прав на обновление' do
        before do
          policy = instance_double(EventPolicy, edit?: false)
          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end

    delete 'удаление' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { current_user.events.first.id }

      context 'когда есть права на удаление' do
        before do
          policy = instance_double(EventPolicy, delete?: true)
          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'удалено' do
          run_test!
        end
      end

      context 'когда нет прав на удаление' do
        let(:policy) { instance_double(EventPolicy, delete?: false) }

        before { allow(EventPolicy).to receive(:can).and_return(policy) }

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end
  end

  path '/v1/events/{id}/update_status' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID'

    put 'обновление статуса' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    status: { type: :string, description: 'Новый статус. Варианты: approved, denied' }
                  },
                  required:   %w[status]
                }

      authorize!

      let(:id)     { current_user.events.first.id }
      let(:params) { { status: :approved }        }

      context 'когда есть права на обновление' do
        before do
          policy = instance_double(EventPolicy, change_status?: true)
          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'обновлён' do
          run_test!
        end
      end

      context 'когда нет прав на обновление' do
        before do
          policy = instance_double(EventPolicy, change_status?: false)
          allow(EventPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end
  end

  path '/v1/events/waiting_for_confirmation' do
    get 'события, ожидающие подтверждения' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      context 'когда юзер - начальник' do
        before do
          allow(current_user).to receive(:boss?).and_return(true)
        end

        response '200', 'события, ожидающие подтверждения' do
          run_test! { expect(response_json[:resources]).to be_present }
        end
      end

      context 'когда юзер - не начальник' do
        before do
          allow(current_user).to receive(:boss?).and_return(false)
        end

        response '200', '__FORBIDDEN__' do
          run_test! { expect(response_json[:resources]).to eq('__FORBIDDEN__') }
        end
      end
    end
  end

  path '/v1/events/processed' do
    get 'обработанные события (те, на которые начальник отреагировал)' do
      tags 'События'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      context 'когда юзер - начальник' do
        before do
          allow(current_user).to receive(:boss?).and_return(true)
        end

        response '200', 'массив событий' do
          run_test! { expect(response_json[:resources]).to be_present }
        end
      end

      context 'когда юзер - не начальник' do
        before do
          allow(current_user).to receive(:boss?).and_return(false)
        end

        response '200', '__FORBIDDEN__' do
          run_test! { expect(response_json[:resources]).to eq('__FORBIDDEN__') }
        end
      end
    end
  end
end
