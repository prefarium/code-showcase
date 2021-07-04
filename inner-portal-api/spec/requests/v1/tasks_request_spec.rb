# frozen_string_literal: true

require 'swagger_helper'

describe 'Tasks' do
  let(:current_user) { create(:user) }

  before do
    create_list(:task, 5, author: current_user)
    create(:task)

    context = Struct.new('Context', :failure?).new(false)

    allow(Task::Assign).to receive(:call).and_return(context)
    allow(Task::ChangeStatus).to receive(:call).and_return(context)
    allow(Task::Cancel).to receive(:call).and_return(context)
    allow(Task::Update).to receive(:call).and_return(context)
  end

  path '/v1/tasks' do
    get 'список' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :user_id,
                in:          :query,
                type:        :integer,
                required:    false,
                description: 'ID пользователя, чьи задачи будут возвращены. ' \
                             'Если не передан, используется ID текущего пользователя'

      parameter name:        :filter,
                in:          :query,
                type:        :string,
                default:     :assigned,
                required:    false,
                examples:    {
                  assigned: { summary: 'является исполнителем', value: :assigned },
                  created:  { summary: 'является автором', value: :created },
                  all:      { summary: 'является или тем, или другим', value: :all }
                },
                description: 'Тип связи пользователя и задач'

      parameter name:        :sorting_field,
                in:          :query,
                type:        :string,
                default:     :deadline,
                required:    false,
                examples:    {
                  title:    { summary: 'по заголовку', value: :title },
                  deadline: { summary: 'по дэдлайну', value: :deadline },
                  status:   { summary: 'по статусу', value: :status }
                },
                description: 'Поле сортировки'

      parameter name:        :sorting_direction,
                in:          :query,
                type:        :string,
                default:     :desc,
                required:    false,
                examples:    {
                  desc_example: { summary: 'по убыванию', value: :desc },
                  asc_example:  { summary: 'по возврастанию', value: :asc }
                },
                description: 'Направление сортировки'

      paginable!
      searchable!
      authorize!

      response '200', 'список задач' do
        context 'когда есть права на просмотр' do
          before do
            policy = instance_double(TaskPolicy, access?: true)

            allow(TaskPolicy).to receive(:can).and_return(policy)
            allow(Tasks::FilteredCollectionQuery).to receive(:call).and_return(Task.none)
          end

          run_test! { expect(response_json).to be_kind_of Hash }
        end

        context 'когда нет прав на просмотр' do
          before do
            policy = instance_double(TaskPolicy, access?: false)
            allow(TaskPolicy).to receive(:can).and_return(policy)
          end

          run_test! { expect(response_json).to eq resources: '__FORBIDDEN__' }
        end
      end
    end

    post 'создание' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    title:       { type: :string, description: 'Заголовок' },
                    deadline:    { type: :string, description: 'Дэдлайн', format: :date },
                    description: { type: :string, description: 'Описание' },
                    assignee_id: { type: :integer, description: 'ID исполнителя' }
                  },
                  required:   %w[title assignee_id]
                }

      authorize!

      response '204', 'создана' do
        let(:params) { { title: '' } }

        run_test!
      end
    end
  end

  path '/v1/tasks/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID'

    get 'просмотр' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { current_user.tasks.first.id }

      context 'когда есть права на просмотр' do
        before do
          policy = instance_double(TaskPolicy, read?: true)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '200', 'задача' do
          run_test! { expect(response_json).not_to be_empty }
        end
      end

      context 'когда нет прав на просмотр' do
        before do
          policy = instance_double(TaskPolicy, read?: false)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end

    put 'редактирование' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    title:       { type: :string, description: 'Заголовок' },
                    deadline:    { type: :string, description: 'Дэдлайн', format: :date },
                    description: { type: :string, description: 'Описание' }
                  }
                }

      authorize!

      let(:id) { current_user.tasks.first.id }
      let(:params) { { status: '' } }

      context 'когда есть права на обновление' do
        before do
          policy = instance_double(TaskPolicy, edit?: true)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'отредактирована' do
          run_test!
        end
      end

      context 'когда нет прав на обновление' do
        before do
          policy = instance_double(TaskPolicy, edit?: false)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end

    delete 'удаление' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { current_user.tasks.first.id }

      context 'когда есть права на удаление' do
        before do
          policy = instance_double(TaskPolicy, delete?: true)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'удалена' do
          run_test!
        end
      end

      context 'когда нет прав на удаление' do
        before do
          policy = instance_double(TaskPolicy, delete?: false)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end
  end

  path '/v1/tasks/{id}/update_status' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID'

    put 'обновление статуса' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    status:        { type:        :string,
                                     description: 'Статус задачи. Варианты: rejected, in_progress, paused, completed' },
                    reject_reason: { type:        :string,
                                     description: 'Причина отказа. Указывается при статусе rejected' }
                  },
                  required:   %w[status]
                }

      authorize!

      let(:id)     { current_user.tasks.first.id }
      let(:params) { { status: '' }              }

      context 'когда есть права на обновление' do
        before do
          policy = instance_double(TaskPolicy, change_status?: true)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'обновлён' do
          run_test!
        end
      end

      context 'когда нет прав на обновление' do
        before do
          policy = instance_double(TaskPolicy, change_status?: false)
          allow(TaskPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end
  end
end
