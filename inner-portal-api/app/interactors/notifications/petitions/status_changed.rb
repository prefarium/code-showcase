# frozen_string_literal: true

module Notifications
  module Petitions
    class StatusChanged
      include Interactor

      def call
        petition = context.petition

        return if petition.created?

        Notifications::PetitionsMailer.public_send(petition.status, petition.author_id, petition.id).deliver_later
      end
    end
  end
end
