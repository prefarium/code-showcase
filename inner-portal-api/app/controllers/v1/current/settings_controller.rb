# frozen_string_literal: true

module V1
  module Current
    class SettingsController < APIController
      def update
        contexts = []

        contexts << User::Update.call(
          user:        current_user,
          user_params: permit_params(user: %i[email phone actual_position])[:user]
        )

        contexts << NotificationSetting::Update.call(
          notification_setting:        current_user.notification_setting,
          notification_setting_params: permit_params(notification_setting: %i[email browser])[:notification_setting]
        )

        telegram_account = current_user.telegram_account
        username         = params.dig(:user, :telegram)
        contexts << if telegram_account.blank? && username.present?
                      TelegramAccount::Create.call(telegram_account_params: { user: current_user, username: username })

                    elsif telegram_account.present? && username.present?
                      TelegramAccount::Update.call(telegram_account:        telegram_account,
                                                   telegram_account_params: { username: username })

                    elsif telegram_account.present? && username == ''
                      TelegramAccount::Destroy.call(telegram_account: telegram_account)
                    end

        errors = contexts.reduce([]) { |err, context| context&.failure? ? err << context.error_message : err }
        render_error(errors.compact.join('. '), :unprocessable_entity) if errors.present?
      end
    end
  end
end
