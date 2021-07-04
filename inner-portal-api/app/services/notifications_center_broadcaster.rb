# frozen_string_literal: true

module NotificationsCenterBroadcaster
  def self.call(user_id)
    notifications = Notification.where(recipient_id: user_id)

    ActionCable.server.broadcast "notifications_center_channel_#{user_id}",
                                 total:         notifications.count,
                                 total_tasks:   notifications.where(notifiable_type: 'Task').count,
                                 total_events:  notifications.where(notifiable_type: 'Event').count,
                                 total_ideas:   notifications.where(notifiable_type: 'Idea').count,
                                 unread:        notifications.where(read: false).count,
                                 unread_tasks:  notifications.where(read: false).where(notifiable_type: 'Task').count,
                                 unread_events: notifications.where(read: false).where(notifiable_type: 'Event').count,
                                 unread_ideas:  notifications.where(read: false).where(notifiable_type: 'Idea').count
  end
end
