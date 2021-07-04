# frozen_string_literal: true

module Landing
  class HistoryMarksController < APIController
    def index
      render json: Landing::HistoryMarkSerializer.render(
        Landing::HistoryMark.order(year: :asc)
      )
    end
  end
end
