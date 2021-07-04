# frozen_string_literal: true

class Survey
  class CreateAndPublish
    include Interactor::Organizer

    organize Create, ChangeCurrent
  end
end
