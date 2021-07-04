# frozen_string_literal: true

class User
  class UpdateWithAvatar
    include Interactor::Organizer

    organize Update, UpdateAvatar
  end
end
