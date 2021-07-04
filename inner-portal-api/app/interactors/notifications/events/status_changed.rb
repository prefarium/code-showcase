# frozen_string_literal: true

module Notifications
  module Events
    class StatusChanged
      include Interactor

      def call
        event  = context.event
        author = event.author

        return unless event.confirmable? && %w[approved denied].include?(event.status)

        notification = Notification.create!(
          recipient_id: author.id,
          title:        I18n.t("notifications.event.confirmable.#{event.status}.title"),
          body:         I18n.t("notifications.event.confirmable.#{event.status}.body",
                               type:  Event.human_attribute_name("type.#{event.type}"),
                               dates: event.dates),
          link:         LinkGenerator.event(event.id, absolute_link: false),
          notifiable:   event
        )

        # Это нужно, чтобы интерактор Cleanup отрабатывал после этого интерактора так же,
        #   как и после Canceled и NewAssigned
        context.notifications = Notification.where(id: notification.id)

        NotificationsBroadcaster.call(notification.id) if author.notification_setting.browser
        EventsMailer.status_changed(author.id, event.id).deliver_later if author.notification_setting.email
      end

      def rollback
        context.notification.destroy!
      end
    end
  end
end
