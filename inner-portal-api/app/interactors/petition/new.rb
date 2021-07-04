# frozen_string_literal: true

class Petition
  class New
    include Interactor::Organizer

    organize Create, Notifications::Petitions::Created
  end
end
