# frozen_string_literal: true

module Notifications
  module Ideas
    class NewCreated
      include Interactor

      def call
        @idea      = context.idea
        recipients = User.where(division_id: @idea.division_id).and(User.where.not(id: @idea.author_id))

        # Массив нужного размера создаётся заранее, что не переисывать его сотни раз
        @notification_ids = Array.new(recipients.count)
        # Индекс передаётся в метод исключительно для того,
        #   чтобы опредеять в какюу ячейку @notification_ids сохранять айдишник уведомления
        recipients.includes(:notification_setting).find_each.with_index { |user, idx| notify(user, idx) }
        context.notifications = Notification.where(id: @notification_ids)
      end

      def rollback
        context.notifications.destroy_all
      end

      private

      def notify(user, idx)
        notification = Notification.create!(
          recipient_id: user.id,
          title:        I18n.t('notifications.idea.new_created.title'),
          body:         I18n.t('notifications.idea.new_created.body',
                               author_name: @idea.author.last_and_first_names,
                               title:       @idea.title),
          link:         LinkGenerator.idea(@idea.id, absolute_link: false),
          notifiable:   @idea
        )

        @notification_ids[idx] = notification.id

        NotificationsBroadcaster.call(notification.id) if user.notification_setting.browser
        IdeasMailer.new_created(user.id, @idea.id).deliver_later if user.notification_setting.email
      end
    end
  end
end
