# frozen_string_literal: true

class Survey
  class UpdateAndPublish
    include Interactor::Organizer

    organize Update, ChangeCurrent
  end
end
