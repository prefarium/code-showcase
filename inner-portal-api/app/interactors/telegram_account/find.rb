# frozen_string_literal: true

class TelegramAccount
  class Find
    include Interactor

    def call
      chat_id          = context.telegram_account_params[:chat_id]
      username         = context.telegram_account_params[:username]
      telegram_account = TelegramAccount.find_by(username: username) || TelegramAccount.find_by(chat_id: chat_id)

      return context.telegram_account = telegram_account if telegram_account

      bot_responses = context.bot_responses ||= []
      bot_responses << I18n.t('bot_messages.account_not_connected')

      context.fail!
    end
  end
end
