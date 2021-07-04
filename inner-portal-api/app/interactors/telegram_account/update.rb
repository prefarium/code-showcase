# frozen_string_literal: true

class TelegramAccount
  class Update
    include Interactor

    def call
      params           = context.telegram_account_params
      telegram_account = context.telegram_account

      context.telegram_account_attributes_backup = telegram_account.attributes

      if telegram_account.update(params)
        context.new_attributes = telegram_account.attributes.symbolize_keys
        context.old_attributes = context.telegram_account_attributes_backup.symbolize_keys

        return
      end

      bot_responses = context.bot_responses ||= []
      bot_responses << I18n.t('bot_messages.account_update_failed')

      context.fail!(error_message: error_messages_of(telegram_account), error_status: :unprocessable_entity)
    end

    def rollback
      context.telegram_account.reload.update!(context.telegram_account_attributes_backup)
    end
  end
end
