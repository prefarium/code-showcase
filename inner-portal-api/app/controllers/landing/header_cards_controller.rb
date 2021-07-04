# frozen_string_literal: true

module Landing
  class HeaderCardsController < APIController
    def index
      render json: Landing::HeaderCardSerializer.render(Landing::HeaderCard.all)
    end
  end
end
