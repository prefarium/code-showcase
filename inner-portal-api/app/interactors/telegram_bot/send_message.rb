# frozen_string_literal: true

module TelegramBot
  class SendMessage
    include Interactor

    URL = "https://api.telegram.org/bot#{ENV['TELEGRAM_BOT_TOKEN']}/sendMessage"

    def call
      Faraday.post(URL, data)
    end

    private

    def data
      {
        chat_id: context.chat_id,
        text:    context.text
      }
    end
  end
end
