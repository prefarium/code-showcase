# frozen_string_literal: true

module Notifiable
  extend ActiveSupport::Concern

  def mark_notification_as_read(model)
    model.notifications.where(recipient_id: current_user.id).mark_as_read
  end

  def update_notification_numbers
    NotificationsCenterBroadcaster.call(current_user.id)
  end
end
