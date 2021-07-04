# frozen_string_literal: true

module Notifications
  class EventsMailer < ApplicationMailer
    EMAILS = [
      { event_type:          :confirmable,
        subject_for_new:     'Новый запрос на согласование',
        subject_for_deleted: 'Запрос на согласование отменён' },
      { event_type:          :not_confirmable,
        subject_for_new:     'Новое событие',
        subject_for_deleted: 'Событие отменено' },
      { event_type:          :common,
        subject_for_new:     'Новое общее событие',
        subject_for_deleted: 'Общее событие отменено' }
    ].freeze

    EMAILS.each do |hash|
      define_method("new_#{hash[:event_type]}") do |recipient_id, event_id|
        @recipient = User.find(recipient_id)
        @event     = Event.find(event_id)
        mail(to: @recipient.email, subject: hash[:subject_for_new])
      end

      define_method("#{hash[:event_type]}_deleted") do |recipient_id, event|
        @recipient = User.find(recipient_id)
        @event     = event
        mail(to: @recipient.email, subject: hash[:subject_for_deleted])
      end
    end

    def status_changed(recipient_id, event_id)
      @recipient      = User.find(recipient_id)
      @event          = Event.find(event_id)
      @status_in_text =
        {
          approved: 'согласован',
          denied:   'отклонён'
        }.stringify_keys.freeze

      mail(to:      @recipient.email,
           subject: "#{Event.human_attribute_name("type.#{@event.type}")} #{@status_in_text[@event.status]}")
    end
  end
end
