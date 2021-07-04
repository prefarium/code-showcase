# frozen_string_literal: true

module Landing
  class NewsController < APIController
    include Pagination

    def index
      news = News.published.for_landing.order(date: :desc)

      render json: collection_for_rendering(news, view: :index)
    end
  end
end
