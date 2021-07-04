# frozen_string_literal: true

require 'swagger_helper'

describe 'Tasks archive' do
  let(:current_user) { create(:user) }

  before do
    create_list(:task, 5, author: current_user)
    current_user.tasks.destroy_all
  end

  path '/v1/tasks/archive' do
    get 'архив' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

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
        run_test! { expect(response_json).to be_kind_of Hash }
      end
    end
  end

  path '/v1/tasks/archive/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID'

    get 'просмотр архивной задачи' do
      tags 'Задачи'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { current_user.tasks.archived.first.id }

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
  end
end
