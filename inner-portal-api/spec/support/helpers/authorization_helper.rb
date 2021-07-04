# frozen_string_literal: true

module AuthorizationHelper
  def authorize!
    security [Bearer: {}]

    let(:Authorization) { "Bearer #{tokens_for(current_user)[:access]}" } # rubocop:disable RSpec/VariableName
  end

  def unauthorize!
    let(:Authorization) { nil } # rubocop:disable RSpec/VariableName
  end
end
