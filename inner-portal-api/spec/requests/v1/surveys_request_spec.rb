# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Surveys', type: :request do
  let(:current_user) { create(:user) }

  before do
    create(:survey)
    create(:survey, status: :current)
  end

  path '/v1/survey' do
    get 'текущий' do
      tags 'Опросы'
      consumes 'application/json'
      produces 'application/json'

      authorize!

      response '200', 'текущий опрос' do
        run_test! { expect(response_json).not_to be_empty }
      end
    end
  end
end
