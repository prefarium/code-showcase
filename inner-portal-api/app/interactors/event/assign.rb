# frozen_string_literal: true

class Event
  class Assign
    include Interactor::Organizer

    organize Create, Notifications::Events::NewAssigned, Notifications::Events::Cleanup
  end
end
