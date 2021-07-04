# frozen_string_literal: true

module V1
  class SurveysController < APIController
    def show
      survey = Survey.current.first
      render json: survey ? SurveySerializer.render_as_hash(survey) : nil
    end
  end
end
