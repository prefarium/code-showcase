# frozen_string_literal: true

class NotificationSetting
  class Update
    include Interactor

    def call
      notification_setting = context.notification_setting
      params               = context.notification_setting_params

      context.notification_setting_attributes_backup = notification_setting.attributes

      return if notification_setting.update(params)

      context.fail!(error_message: error_messages_of(notification_setting), error_status: :unprocessable_entity)
    end

    def rollback
      context.notification_setting.reload.update!(context.notification_setting_attributes_backup)
    end
  end
end
