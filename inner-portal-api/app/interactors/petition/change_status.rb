# frozen_string_literal: true

class Petition
  class ChangeStatus
    include Interactor::Organizer

    organize Update, Notifications::Petitions::StatusChanged, SendToDirector
  end
end
