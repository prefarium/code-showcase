# frozen_string_literal: true

class TelegramAccount
  class Destroy
    include Interactor

    def call
      telegram_account = context.telegram_account

      return if telegram_account.destroy

      context.fail!(error_message: error_messages_of(telegram_account), error_status: :unprocessable_entity)
    end

    def rollback
      context.telegram_account = context.telegram_account.dup
      context.telegram_account.save!
    end
  end
end
