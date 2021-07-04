# frozen_string_literal: true

require 'swagger_helper'

describe 'News' do
  let(:current_user) { create(:user) }

  before do
    create_list(:news, 5, status: :published)
    create(:news, status: :created)
    create(:news, status: :archived)

    context = Struct.new('Context', :failure?).new(false)
    allow(News::CreateWithImage).to receive(:call).and_return(context)
  end

  path '/v1/news' do
    get 'список' do
      tags 'Новости'
      consumes 'application/json'
      produces 'application/json'

      paginable!
      authorize!

      response '200', 'спикок новостей' do
        run_test! { expect(response_json[:resources].count).to eq(5) }
      end
    end

    post 'предложение новой' do
      tags 'Новости'
      consumes 'application/json'
      produces 'application/json'

      parameter name:   :params,
                in:     :body,
                schema: {
                  type:       :object,
                  properties: {
                    title: { type: :string, description: 'Заголовок' },
                    body:  { type: :string, description: 'Содержание' },
                    date:  { type: :string, description: 'Желаемая дата публикации', format: :date },
                    image: { type: :image, description: 'Изображение', format: :binary }
                  },
                  required:   %w[title body date]
                }

      authorize!

      response '204', 'отправлено на рассмотрение' do
        let(:params) { { title: '', body: '', date: '', image: '' } }

        run_test!
      end
    end
  end

  path '/v1/news/{id}' do
    parameter name:        :id,
              in:          :path,
              type:        :integer,
              required:    true,
              description: 'ID'

    get 'просмотр' do
      tags 'Новости'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      response '200', 'новость' do
        let(:id) { News.published.first.id }

        run_test! { expect(response_json).not_to be_empty }
      end
    end
  end
end
