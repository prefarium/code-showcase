# frozen_string_literal: true

class Task
  class ChangeStatus
    include Interactor::Organizer

    organize Update, Notifications::Tasks::StatusChanged, Notifications::Tasks::Cleanup
  end
end
