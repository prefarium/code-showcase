# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Petitions', type: :request do
  let(:current_user) { create(:user) }

  before do
    context = Struct.new('Context', :failure?).new(false)
    allow(Petition::Create).to receive(:call).and_return(context)
  end

  path '/v1/petitions' do
    post 'создание' do
      tags 'Обращения'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    title: { type: :string, description: 'Заголовок' },
                    body:  { type: :string, description: 'Суть' }
                  },
                  required:   %i[title body]
                }

      authorize!

      response '204', 'отправлено на рассмотрение' do
        let(:params) { { title: '', body: '' } }

        run_test!
      end
    end
  end
end
