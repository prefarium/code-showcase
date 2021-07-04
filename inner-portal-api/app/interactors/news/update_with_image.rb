# frozen_string_literal: true

class News
  class UpdateWithImage
    include Interactor::Organizer

    organize Update, UpdateImage
  end
end
