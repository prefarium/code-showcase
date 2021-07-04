# frozen_string_literal: true

module Notifications
  module Events
    class Canceled
      include Interactor

      def call
        @event = context.event

        recipients = case @event.real_type
                     when :common
                       User.all
                     when :confirmable
                       User.where(id: @event.author.boss.id)
                     when :not_confirmable
                       context.event_participants.where.not(id: @event.author_id)
                     else
                       User.none
                     end

        # Массив нужного размера создаётся заранее, что не переисывать его сотни раз при общих событиях
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
        title, body = case @event.real_type
                      when :common
                        [
                          I18n.t('notifications.event.common.canceled.title'),
                          I18n.t('notifications.event.common.canceled.body', title: @event.title)
                        ]
                      when :confirmable
                        [
                          I18n.t('notifications.event.confirmable.canceled.title'),
                          I18n.t('notifications.event.confirmable.canceled.body',
                                 type:        Event.human_attribute_name("type.#{@event.type}"),
                                 author_name: @event.author.last_and_first_names)
                        ]
                      else
                        [
                          I18n.t('notifications.event.not_confirmable.canceled.title'),
                          I18n.t('notifications.event.not_confirmable.canceled.body', title: @event.title)
                        ]
                      end

        notification = Notification.create!(
          recipient_id: user.id,
          title:        title,
          body:         body,
          link:         LinkGenerator.event(@event.id, absolute_link: false),
          notifiable:   @event
        )

        @notification_ids[idx] = notification.id

        NotificationsBroadcaster.call(notification.id) if user.notification_setting.browser

        return unless user.notification_setting.email

        EventsMailer.public_send("#{event_type}_deleted", user.id, @event).deliver_later
      end
    end
  end
end
