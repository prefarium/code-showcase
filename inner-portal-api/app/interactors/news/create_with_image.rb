# frozen_string_literal: true

class News
  class CreateWithImage
    include Interactor::Organizer

    organize Create, UpdateImage
  end
end
