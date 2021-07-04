# frozen_string_literal: true

module V1
  class NotificationsController < APIController
    include Pagination
    include Notifiable

    before_action :set_notifications
    after_action :update_notification_numbers, only: %i[mark_as_read clear]

    def index
      render json: collection_for_rendering(@notifications)
    end

    def mark_as_read
      @notifications.mark_as_read
    end

    def clear
      @notifications.destroy_all
    end

    private

    def set_notifications
      @notifications = current_user.notifications
                                   .with_type(params[:notifiable_type])
                                   .order(read: :asc)
                                   .order(created_at: :desc)
    end
  end
end
