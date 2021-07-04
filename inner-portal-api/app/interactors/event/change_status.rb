# frozen_string_literal: true

class Event
  class ChangeStatus
    include Interactor::Organizer

    organize Update, Notifications::Events::StatusChanged
  end
end
