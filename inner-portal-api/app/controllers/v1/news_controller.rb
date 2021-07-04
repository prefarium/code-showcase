# frozen_string_literal: true

module V1
  class NewsController < APIController
    include Pagination

    def index
      news = News.published.for_portal.order(date: :desc)

      render json: collection_for_rendering(news, view: :index)
    end

    def show
      news = News.published.find(params[:id])

      render json: NewsSerializer.render_as_hash(news, view: :show)
    end

    def create
      context = News::CreateWithImage.call(news_params)

      render_error_from_context(context) if context.failure?
    end

    private

    def news_params
      {
        news_params: permit_params(:body, :date, :title).merge(author: current_user),
        image:       params[:image]
      }
    end
  end
end
