# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Selectors', type: :request do
  let(:current_user) { create(:user) }

  let(:head) do
    create(:user, role: :head, division: current_user.division)
      .tap { |user| user.controlled_divisions << user.division }
  end

  let(:director) do
    create(:user, role: :director)
      .tap { |user| user.controlled_divisions << user.division }
  end

  before do
    create_list(:user, 3, division: current_user.division)
    create_list(:user, 4, role: :deputy, division: director.division)
  end

  path '/v1/selectors/event_types' do
    get 'типы событий' do
      tags 'Селекторы'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      response '200', 'список типов событий' do
        run_test! { expect(response_json).to eq(Event.types.keys) }
      end
    end
  end

  path '/v1/selectors/possible_assignees' do
    get 'список тех, для кого можно создавать события и задачи' do
      tags 'Селекторы'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      response '200', 'список тех, для кого можно создавать события и задачи' do
        context 'когда пользователь - простой смертный' do
          run_test! { expect(response_json.size).to eq 4 }
        end

        context 'когда пользователь - начальник отдела' do
          before do
            current_user.head!
            current_user.controlled_divisions << current_user.division

            head.mortal!
            head.controls.destroy_all
          end

          after do
            current_user.mortal!
            current_user.controls.destroy_all

            head.head!
            head.controlled_divisions << head.division
          end

          run_test! { expect(response_json.size).to eq 5 }
        end

        context 'когда пользователь - зам директора' do
          before do
            current_user.update!(role: :deputy, division_id: director.division_id)
            current_user.controlled_divisions << head.division
          end

          after do
            current_user.mortal!
            current_user.controls.destroy_all
          end

          run_test! { expect(response_json.size).to eq 6 }
        end

        context 'когда пользователь - директор' do
          before do
            director.deputy!
            director.controls.destroy_all

            current_user.update!(role: :director, division_id: director.division_id)
            current_user.controlled_divisions << current_user.division
          end

          after do
            current_user.mortal!
            current_user.controls.destroy_all

            director.director!
            director.controlled_divisions << director.division
          end

          run_test! { expect(response_json.size).to eq 6 }
        end
      end
    end
  end
end
