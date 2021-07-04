# frozen_string_literal: true

require 'swagger_helper'

describe 'Ideas', type: :request do
  let(:current_user) { create(:user) }

  before do
    create_list(:idea, 6, author: current_user)
    create(:pin, idea: Idea.last, pinner: current_user)
    create(:idea, status: :approved, author: current_user)
    create(:idea, status: :denied, author: current_user)
    create(:idea)

    context = Struct.new('Context', :failure?).new(false)
    allow(Idea::Create).to receive(:call).and_return(context)
  end

  path '/v1/ideas' do
    get 'список незакреплённых' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :user_id,
                in:          :query,
                type:        :integer,
                required:    false,
                description: 'ID пользователя, чьи идеи будут возвращены. ' \
                             'По умолчанию используется текущий пользователь'

      parameter name:        :for_division,
                in:          :query,
                type:        :boolean,
                default:     true,
                required:    false,
                description: 'Требуется ли вернуть идеи подразделения, в котором работает владелец user_id'

      parameter name:        :filter,
                in:          :query,
                type:        :string,
                default:     :active,
                required:    false,
                description: 'Статус возвращаемых идей',
                examples:    {
                  active:   { summary: 'голосование идёт', value: :active },
                  ended:    { summary: 'голосование закончилось', value: :ended },
                  approved: { summary: 'одобренные', value: :approved },
                  denied:   { summary: 'отклонённые', value: :denied }
                }

      paginable!
      authorize!

      response '200', 'список событий' do
        context 'когда есть права на просмотр' do
          before do
            policy = instance_double(IdeaPolicy, access?: true)

            allow(IdeaPolicy).to receive(:can).and_return(policy)
            allow(Ideas::FilteredCollectionQuery).to receive(:call).and_return(Idea.none)
          end

          run_test! { expect(response_json).to be_kind_of Hash }
        end

        context 'когда нет прав на просмотр' do
          before do
            policy = instance_double(IdeaPolicy, access?: false)
            allow(IdeaPolicy).to receive(:can).and_return(policy)
          end

          run_test! { expect(response_json).to eq resources: '__FORBIDDEN__' }
        end
      end
    end

    post 'создание' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    title:       { type: :string, description: 'Заголовок' },
                    description: { type: :string, description: 'Описание' },
                    end_date:    { type: :string, description: 'Дата окончания голосования', format: :date }
                  },
                  required:   %w[title end_date]
                }

      authorize!

      response '204', 'создана' do
        let(:params) { { title: '', end_date: '' } }

        run_test!
      end
    end
  end

  path '/v1/ideas/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID'

    get 'просмотр' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { Idea.first.id }

      context 'когда есть права на просмотр' do
        before do
          policy = instance_double(IdeaPolicy, read?: true)
          allow(IdeaPolicy).to receive(:can).and_return(policy)
        end

        response '200', 'идея' do
          run_test! { expect(response_json).not_to be_empty }
        end
      end

      context 'когда нет прав на просмотр' do
        before do
          policy = instance_double(IdeaPolicy, read?: false)
          allow(IdeaPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end
  end

  path '/v1/ideas/pinned' do
    get 'список закреплённых' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :filter,
                in:          :query,
                type:        :string,
                default:     :active,
                required:    false,
                description: 'Статус возвращаемых идей',
                examples:    {
                  active:   { summary: 'голосование идёт', value: :active },
                  ended:    { summary: 'голосование закончилось', value: :ended },
                  approved: { summary: 'одобренные', value: :approved },
                  denied:   { summary: 'отклонённые', value: :denied }
                }

      paginable!
      authorize!

      response '200', 'список закреплённых идей' do
        run_test! { expect(response_json[:resources].count).to eq(1) }
      end
    end
  end

  path '/v1/ideas/aside' do
    get 'список для бокового блока' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      response '200', 'список для бокового блока' do
        run_test! { expect(response_json.count).to eq(3) }
      end
    end
  end

  path '/v1/ideas/search' do
    get 'поиск' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      paginable!
      searchable!
      authorize!

      response '200', 'список найденных идей' do
        run_test!
      end
    end
  end
end
