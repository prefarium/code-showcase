# frozen_string_literal: true

class PetitionsMailer < ApplicationMailer
  def petition_for_director(petition_id)
    @petition = Petition.find(petition_id)
    mail(to: ENV['EMAIL_FOR_PETITIONS'], subject: 'Новое обращение')
  end
end
