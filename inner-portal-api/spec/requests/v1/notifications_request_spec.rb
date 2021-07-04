# frozen_string_literal: true

require 'swagger_helper'

describe 'Notifications' do
  let(:current_user) { create(:user) }

  path '/v1/notifications' do
    get 'список' do
      tags 'Центр уведомлений'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :notifiable_type,
                in:          :query,
                type:        :string,
                required:    false,
                examples:    {
                  all:   { summary: 'все', value: nil },
                  task:  { summary: 'задачи', value: 'Task' },
                  event: { summary: 'события', value: 'Event' },
                  idea:  { summary: 'идеи', value: 'Idea' }
                },
                description: 'Тип уведомлений. Если ничего не передано, вернутся все'

      paginable!
      authorize!

      response '200', 'список уведомлений' do
        run_test! { expect(response_json).to be_kind_of Hash }
      end
    end
  end

  path '/v1/notifications' do
    put 'пометка уведомлений прочитанными' do
      tags 'Центр уведомлений'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :notifiable_type,
                in:          :query,
                type:        :string,
                required:    false,
                examples:    {
                  all:   { summary: 'все', value: nil },
                  task:  { summary: 'задачи', value: 'Task' },
                  event: { summary: 'события', value: 'Event' },
                  idea:  { summary: 'идеи', value: 'Idea' }
                },
                description: 'Тип уведомлений. Если ничего не передано, будут помечены все'

      authorize!

      response '204', 'помечено' do
        run_test!
      end
    end
  end

  path '/v1/notifications' do
    delete 'очистить центр уведомлений' do
      tags 'Центр уведомлений'
      consumes 'application/json'
      produces 'application/json'

      parameter name:        :notifiable_type,
                in:          :query,
                type:        :string,
                required:    false,
                examples:    {
                  all:   { summary: 'все', value: nil },
                  task:  { summary: 'задачи', value: 'Task' },
                  event: { summary: 'события', value: 'Event' },
                  idea:  { summary: 'идеи', value: 'Idea' }
                },
                description: 'Тип уведомлений. Если ничего не передано, удалятся все'

      authorize!

      response '204', 'очищено' do
        run_test!
      end
    end
  end
end
