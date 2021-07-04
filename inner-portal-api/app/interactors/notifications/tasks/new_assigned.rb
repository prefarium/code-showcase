# frozen_string_literal: true

module Notifications
  module Tasks
    class NewAssigned
      include Interactor

      def call
        task     = context.task
        assignee = task.assignee

        return if task.author_id == task.assignee_id

        notification = context.notification = Notification.create!(
          recipient_id: assignee.id,
          title:        I18n.t('notifications.task.new_assigned.title'),
          body:         I18n.t('notifications.task.new_assigned.body', title: task.title),
          link:         LinkGenerator.task(task.id, absolute_link: false),
          notifiable:   task
        )

        NotificationsBroadcaster.call(notification.id) if assignee.notification_setting.browser
        TasksMailer.new_assigned(assignee.id, task.id).deliver_later if assignee.notification_setting.email
      end

      def rollback
        context.notification.destroy!
      end
    end
  end
end
