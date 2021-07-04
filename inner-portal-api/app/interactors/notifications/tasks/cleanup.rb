# frozen_string_literal: true

module Notifications
  module Tasks
    class Cleanup
      include Interactor

      def call
        task                         = context.task
        notification                 = context.notification

        return if notification.blank?

        notifications_to_destroy     = task.notifications.where.not(id: notification.id)
        context.notifications_backup = notifications_to_destroy.dup

        context.fail!(error_message: I18n.t('errors.notifications.fail')) unless notifications_to_destroy.destroy_all
      end

      def rollback
        context.notifications_backup.each { |ntf| ntf.dup.save! }
      end
    end
  end
end
