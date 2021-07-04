# frozen_string_literal: true

module Notifications
  module Petitions
    class Created
      include Interactor

      def call
        petition = context.petition

        Notifications::PetitionsMailer.admin_notification(petition.id).deliver_later
        Notifications::PetitionsMailer.created(petition.author_id, petition.id).deliver_later
      end
    end
  end
end
