# frozen_string_literal: true

class News
  class Create
    include Interactor

    def call
      params = context.news_params
      news   = context.news = News.new(params)

      return if news.save

      context.fail!(error_message: error_messages_of(news), error_status: :unprocessable_entity)
    end

    def rollback
      context.news.reload.destroy!
    end
  end
end
