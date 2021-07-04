# frozen_string_literal: true

require 'swagger_helper'

describe 'Аватары', type: :request do
  let(:current_user) { create(:user) }

  before do
    context = Struct.new('Context', :failure?).new(false)
    allow(User::UpdateAvatar).to receive(:call).and_return(context)
  end

  path '/v1/current/avatar' do
    put 'обновление аватара' do
      tags 'Текущий пользователь'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    avatar: { type: :string, description: 'Аватар', format: :binary }
                  },
                  required:   %w[avatar]
                }

      authorize!

      response '200', 'обновлён' do
        let(:params) { { avatar: '' } }

        run_test! { expect(response_json).not_to be_empty }
      end
    end
  end
end
