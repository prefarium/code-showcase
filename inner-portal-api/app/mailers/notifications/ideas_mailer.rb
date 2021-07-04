# frozen_string_literal: true

module Notifications
  class IdeasMailer < ApplicationMailer
    def new_created(recipient_id, idea_id)
      @recipient = User.find(recipient_id)
      @idea      = Idea.find(idea_id)
      mail(to: @recipient.email, subject: 'Новая идея в вашем подразделении!')
    end

    def voting_ended_for_author(recipient_id, idea_id)
      @recipient = User.find(recipient_id)
      @idea      = Idea.find(idea_id)
      mail(to: @recipient.email, subject: 'Голосование за вашу идеи завершено')
    end

    def voting_ended_for_colleagues(recipient_id, idea_id)
      @recipient = User.find(recipient_id)
      @idea      = Idea.find(idea_id)
      mail(to: @recipient.email, subject: 'Завершилось голосование за идею в вашем подразделении')
    end
  end
end
