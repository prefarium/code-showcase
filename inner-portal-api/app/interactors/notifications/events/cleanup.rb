# frozen_string_literal: true

module Notifications
  module Events
    class Cleanup
      include Interactor

      def call
        event                        = context.event
        notifications                = context.notifications

        return if notifications.blank?

        notifications_to_destroy     = event.notifications.where.not(id: notifications.ids)
        context.notifications_backup = notifications_to_destroy.dup

        context.fail!(error_message: I18n.t('errors.notifications.fail')) unless notifications_to_destroy.destroy_all
      end

      def rollback
        context.notifications_backup.each { |ntf| ntf.dup.save! }
      end
    end
  end
end
