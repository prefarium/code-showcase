# frozen_string_literal: true

module Notifications
  module Tasks
    class StatusChanged
      include Interactor

      def call
        task     = context.task
        author   = task.author
        assignee = task.assignee

        return if task.author_id == task.assignee_id

        notification = context.notification = Notification.create!(
          recipient_id: task.author_id,
          title:        I18n.t("notifications.task.#{task.status}.title"),
          body:         I18n.t("notifications.task.#{task.status}.body",
                               assignee_name: assignee.last_and_first_names,
                               title:         task.title),
          link:         LinkGenerator.task(task.id, absolute_link: false),
          notifiable:   task
        )

        NotificationsBroadcaster.call(notification.id) if author.notification_setting.browser
        TasksMailer.status_changed(author.id, task.id).deliver_later if author.notification_setting.email
      end

      def rollback
        context.notification.destroy!
      end
    end
  end
end
