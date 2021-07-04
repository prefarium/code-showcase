# frozen_string_literal: true

module Notifications
  class PetitionsMailer < ApplicationMailer
    def admin_notification(petition_id)
      @petition = Petition.find(petition_id)
      mail(to: ENV['ADMIN_EMAIL'], subject: 'Новое обращение к директору')
    end

    def created(recipient_id, petition_id)
      @recipient = User.find(recipient_id)
      @petition  = Petition.find(petition_id)
      mail(to: @recipient.email, subject: 'Обращение зарегистрировано')
    end

    def approved(recipient_id, petition_id)
      @recipient = User.find(recipient_id)
      @petition  = Petition.find(petition_id)
      mail(to: @recipient.email, subject: 'Обращение одобрено')
    end

    def denied(recipient_id, petition_id)
      @recipient = User.find(recipient_id)
      @petition  = Petition.find(petition_id)
      mail(to: @recipient.email, subject: 'Обращение отклонено')
    end
  end
end
