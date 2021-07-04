# frozen_string_literal: true

class Survey
  class ChangeCurrent
    include Interactor

    def call
      survey = context.survey

      return if !survey.current? || Survey.current.count == 1

      previous_current_surveys = Survey.current.where.not(id: survey.id)

      context.survey_status_backup = survey.status
      context.archived_surveys     = previous_current_surveys.each(&:archived!)
    end

    def rollback
      context.survey.relaod.update!(status: context.survey_status_backup)
      context.archived_surveys.each(&:current!)
    end
  end
end
