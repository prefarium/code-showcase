# frozen_string_literal: true

module Notifications
  module Ideas
    class VotingEnded
      include Interactor

      def call
        @idea = context.idea

        context.fail!(error_message: I18n.t('errors.ideas.voting_not_ended')) unless @idea.ended?

        recipients = User.where(division_id: @idea.division_id)

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
        key = user.id == @idea.author_id ? 'for_author' : 'for_colleagues'

        notification = Notification.create!(
          recipient_id: user.id,
          title:        I18n.t("notifications.idea.voting_ended.#{key}.title"),
          body:         I18n.t("notifications.idea.voting_ended.#{key}.body",
                               title:          @idea.title,
                               total_likes:    @idea.total_likes,
                               total_dislikes: @idea.total_dislikes),
          link:         LinkGenerator.idea(@idea.id, absolute_link: false),
          notifiable:   @idea
        )

        @notification_ids[idx] = notification.id

        NotificationsBroadcaster.call(notification.id) if user.notification_setting.browser

        return unless user.notification_setting.email

        IdeasMailer.public_send("voting_ended_#{key}", user.id, @idea.id).deliver_later
      end
    end
  end
end
