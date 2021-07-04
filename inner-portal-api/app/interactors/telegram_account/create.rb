# frozen_string_literal: true

class TelegramAccount
  class Create
    include Interactor

    def call
      params           = context.telegram_account_params
      telegram_account = context.telegram_account = TelegramAccount.new(params)

      if TelegramAccount.find_by(user_id: telegram_account.user_id)
        context.fail!(error_message: I18n.t('errors.telegram_account.already_exist'),
                      error_status:  :unprocessable_entity)
      end

      return if telegram_account.save

      context.fail!(error_message: error_messages_of(telegram_account), error_status: :unprocessable_entity)
    end

    def rollback
      context.telegram_account.reload.destroy!
    end
  end
end
