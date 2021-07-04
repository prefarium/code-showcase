# frozen_string_literal: true

require 'swagger_helper'

describe 'Votes' do
  let(:current_user) { create(:user)                       }
  let(:idea)         { create(:idea, author: current_user) }

  before do
    context = Struct.new('Context', :failure?).new(false)
    allow(Idea::Vote).to receive(:call).and_return(context)
  end

  path '/v1/ideas/{id}/vote' do
    parameter name:        :id,
              in:          :path,
              type:        :string,
              required:    true,
              description: 'ID идеи'

    put 'голосование' do
      tags 'Идеи'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    vote: { type: :string, description: 'Голос: like, dislike' }
                  },
                  required:   %w[vote]
                }

      authorize!

      let(:id) { idea.id }
      let(:params) { { vote: '' } }

      context 'когда есть права на голосование' do
        before do
          policy = instance_double(IdeaPolicy, vote?: true)
          allow(IdeaPolicy).to receive(:can).and_return(policy)
        end

        response '204', 'голос отдан' do
          run_test!
        end
      end

      context 'когда нет прав на голосование' do
        before do
          policy = instance_double(IdeaPolicy, vote?: false)
          allow(IdeaPolicy).to receive(:can).and_return(policy)
        end

        response '403', 'нет доступа' do
          run_test!
        end
      end
    end
  end
end
