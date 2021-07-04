# frozen_string_literal: true

require 'swagger_helper'

describe 'Pins' do
  let(:current_user) { create(:user)                       }
  let(:idea)         { create(:idea, author: current_user) }

  before do
    context = Struct.new('Context', :failure?).new(false)

    allow(Idea::PinOne).to receive(:call).and_return(context)
    allow(Idea::Unpin).to receive(:call).and_return(context)
  end

  path '/v1/pins' do
    post 'закрепить' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    id: { type: :integer, description: 'ID идеи' }
                  },
                  required:   %w[id]
                }

      authorize!

      let(:params) { { id: idea.id } }

      context 'когда есть права на закрепление' do
        before do
          policy = instance_double(IdeaPolicy, pin?: true)
          allow(IdeaPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'закреплено' do
          run_test!
        end
      end

      context 'когда нет прав на закрепление' do
        before do
          policy = instance_double(IdeaPolicy, pin?: false)
          allow(IdeaPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end
  end

  path '/v1/pins/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :string,
              required:    true,
              description: 'ID идеи'

    delete 'открепление' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      let(:id) { idea.id }

      response '204', 'откреплено' do
        run_test!
      end
    end
  end
end
