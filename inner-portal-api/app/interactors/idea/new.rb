# frozen_string_literal: true

class Idea
  class New
    include Interactor::Organizer

    organize Create, Notifications::Ideas::NewCreated
  end
end
