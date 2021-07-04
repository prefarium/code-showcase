# frozen_string_literal: true

class Event
  class Cancel
    include Interactor::Organizer

    organize Destroy, Notifications::Events::Canceled, Notifications::Events::Cleanup
  end
end
