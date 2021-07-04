# frozen_string_literal: true

class Task
  class Cancel
    include Interactor::Organizer

    organize Destroy, Notifications::Tasks::Canceled, Notifications::Tasks::Cleanup
  end
end
