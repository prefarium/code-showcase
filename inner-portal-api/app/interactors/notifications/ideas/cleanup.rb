# frozen_string_literal: true

module Notifications
  module Ideas
    class Cleanup
      include Interactor

      def call
        idea                         = context.idea
        notifications                = context.notifications

        return if notifications.blank?

        notifications_to_destroy     = idea.notifications.where.not(id: notifications.ids)
        context.notifications_backup = notifications_to_destroy.dup

        context.fail!(error_message: I18n.t('errors.notifications.fail')) unless notifications_to_destroy.destroy_all
      end

      def rollback
        context.notifications_backup.each { |ntf| ntf.dup.save! }
      end
    end
  end
end
