# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Пользователи', type: :request do
  let(:current_user) { create(:user) }

  before do
    create_list(:user, 4, division: current_user.division)

    allow(Users::FilteredCollectionQuery).to receive(:call).and_return(User.all)
  end

  path '/v1/users' do
    get 'список' do
      tags 'Пользователи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :filter,
                in:          :query,
                type:        :string,
                default:     :all,
                required:    false,
                examples:    {
                  all:      { summary: 'все', value: :all },
                  managers: { summary: 'руководители подразделений', value: :managers }
                },
                description: 'Тип возвращаемых пользователей'

      parameter name:        :division_id,
                in:          :query,
                type:        :integer,
                required:    false,
                description: 'ID подразделения, работников которого требуется вернуть'

      parameter name:        :sorting_field,
                in:          :query,
                type:        :string,
                default:     :date,
                required:    false,
                examples:    {
                  name:     { summary: 'по имени', value: :name },
                  division: { summary: 'по подразделению', value: :division },
                  position: { summary: 'по должности', value: :position },
                  email:    { summary: 'по электронной почте', value: :email },
                  phone:    { summary: 'по номеру телефона', value: :phone }
                },
                description: 'Поле сортировки'

      parameter name:        :sorting_direction,
                in:          :query,
                type:        :string,
                default:     :desc,
                required:    false,
                examples:    {
                  desc: { summary: 'по убыванию', value: :desc },
                  asc:  { summary: 'по возврастанию', value: :asc }
                },
                description: 'Направление сортировки'

      paginable!
      searchable!
      authorize!

      response '200', 'список пользователей' do
        run_test! { expect(response_json[:resources].count).to eq(5) }
      end
    end
  end

  path '/v1/users/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :string,
              required:    true,
              description: 'ID'

    get 'профиль' do
      tags 'Пользователи'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { current_user.id }

      response '200', 'страница пользователя' do
        run_test! { expect(response_json[:id]).to eq(current_user.id) }
      end
    end
  end
end
