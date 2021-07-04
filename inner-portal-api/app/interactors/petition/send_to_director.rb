# frozen_string_literal: true

class Petition
  class SendToDirector
    include Interactor

    def call
      petition = context.petition

      return unless petition.approved?

      PetitionsMailer.petition_for_director(petition.id).deliver_later
    end
  end
end
