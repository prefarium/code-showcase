# frozen_string_literal: true

class Feedback
  class New
    include Interactor::Organizer

    organize Create, AttachFile
  end
end
