# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Feedbacks', type: :request do
  let(:current_user) { create(:user) }

  before do
    context = Struct.new('Context', :failure?).new(false)
    allow(Feedback::New).to receive(:call).and_return(context)
  end

  path '/v1/feedback' do
    post 'создание' do
      tags 'Обратная связь'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    body: { type: :string, description: 'Содержание' },
                    file: { type: :string, description: 'Файл', format: :binary }
                  },
                  required:   %i[body]
                }

      authorize!

      response '204', 'отправлено' do
        let(:params) { { body: '' } }

        run_test!
      end
    end
  end
end
