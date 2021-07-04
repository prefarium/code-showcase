# frozen_string_literal: true

require 'swagger_helper'

describe 'Documents', type: :request do
  let(:current_user) { create(:user) }

  before { create_list(:document, 2) }

  path '/v1/documents' do
    get 'список' do
      tags 'Документы'
      consumes 'application/json'
      produces 'application/json'

      paginable!
      authorize!

      response '200', 'список документов' do
        run_test! { expect(response_json[:resources].count).to eq(2) }
      end
    end
  end
end
