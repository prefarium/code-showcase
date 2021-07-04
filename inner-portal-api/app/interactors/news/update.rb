# frozen_string_literal: true

class News
  class Update
    include Interactor

    def call
      news   = context.news
      params = context.news_params

      context.news_attributes_backup = news.attributes

      return if news.update(params)

      context.fail!(error_message: error_messages_of(news), status: :unprocessable_entity)
    end

    def rollback
      context.news.reload.update!(context.news_attributes_backup)
    end
  end
end
