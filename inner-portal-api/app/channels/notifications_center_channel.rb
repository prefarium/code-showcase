# frozen_string_literal: true

class NotificationsCenterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_center_channel_#{current_user.id}"
    NotificationsCenterBroadcaster.call(current_user.id)
  end
end
