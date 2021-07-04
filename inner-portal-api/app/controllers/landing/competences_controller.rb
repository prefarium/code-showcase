# frozen_string_literal: true

module Landing
  class CompetencesController < APIController
    include Pagination

    def index
      render json: collection_for_rendering(Landing::Competence.all, serializer: Landing::CompetenceSerializer)
    end
  end
end
