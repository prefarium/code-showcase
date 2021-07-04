# frozen_string_literal: true

class NotificationSetting
  class Create
    include Interactor

    def call
      user                 = context.user
      notification_setting = context.notification_setting = NotificationSetting.new(user: user)

      return if notification_setting.save

      context.fail!(error_message: error_messages_of(notification_setting), error_status: :unprocessable_entity)
    end

    def rollback
      context.notification_setting.reload.destroy!
    end
  end
end
