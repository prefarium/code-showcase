# frozen_string_literal: true

class Survey
  class Update
    include Interactor

    def call
      params = context.survey_params
      survey = context.survey

      context.survey_attributes_backup = survey.attributes

      return if survey.update(params)

      context.fail!(error_message: error_messages_of(survey), error_status: :unprocessable_entity)
    end

    def rollback
      context.survey.reload.update!(context.survey_attributes_backup)
    end
  end
end
