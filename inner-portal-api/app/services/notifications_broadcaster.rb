# frozen_string_literal: true

module NotificationsBroadcaster
  def self.call(notification_id)
    notification = Notification.find(notification_id)

    ActionCable.server.broadcast "notifications_channel_#{notification.recipient_id}",
                                 title: notification.title,
                                 body:  notification.body,
                                 link:  notification.link

    NotificationsCenterBroadcaster.call(notification.recipient_id)
  end
end
