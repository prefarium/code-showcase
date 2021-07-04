# frozen_string_literal: true

class Task
  class Assign
    include Interactor::Organizer

    organize Create, Notifications::Tasks::NewAssigned, Notifications::Tasks::Cleanup
  end
end
