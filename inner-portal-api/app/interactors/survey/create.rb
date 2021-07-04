# frozen_string_literal: true

class Survey
  class Create
    include Interactor

    def call
      params = context.survey_params
      survey = context.survey = Survey.new(params)

      return if survey.save

      context.fail!(error_message: error_messages_of(survey), error_status: :unprocessable_entity)
    end

    def rollback
      context.survey.reload.destroy!
    end
  end
end
