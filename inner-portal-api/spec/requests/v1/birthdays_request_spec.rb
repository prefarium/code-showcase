# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Birthdays', type: :request do
  let(:current_user) { create(:user) }
  let(:colleagues) do
    create_list(:user, 2, birth_date: Date.current, division: current_user.division)
    User.order(id: :desc).limit(2)
  end

  before do
    allow(Users::Birthdays::InDaysQuery).to receive(:call).and_return(colleagues)
    allow(Users::Birthdays::UpcomingQuery).to receive(:call).and_return(colleagues)
  end

  path '/v1/birthdays' do
    get 'дни рождения коллег за период' do
      tags 'Дни рождения'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :month,
                in:          :query,
                type:        :integer,
                required:    false,
                description: 'Месяц, за который требуется отобразить дни рождения. По умолчанию используется текущий'

      parameter name:        :day,
                in:          :query,
                type:        :integer,
                default:     nil,
                required:    false,
                description: 'День, за который требуется отобразить дни рождения'

      parameter name:        :limit,
                in:          :query,
                type:        :integer,
                default:     nil,
                required:    false,
                description: 'Сколько записей требуется вернуть'

      authorize!

      response '200', 'список имениннков' do
        run_test! { expect(response_json.count).to eq 2 }
      end
    end
  end

  path '/v1/birthdays/upcoming' do
    get 'грядущие дни рождения коллег' do
      tags 'Дни рождения'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :number_of_birthdays,
                in:          :query,
                type:        :integer,
                default:     6,
                required:    false,
                description: 'Количество коллег с ближайшими днями рождения'

      authorize!

      response '200', 'список имениннков' do
        run_test! { expect(response_json.count).to eq 2 }
      end
    end
  end
end
