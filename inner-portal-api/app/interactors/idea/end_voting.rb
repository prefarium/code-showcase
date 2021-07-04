# frozen_string_literal: true

class Idea
  class EndVoting
    include Interactor::Organizer

    organize Update, DeletePins, Notifications::Ideas::VotingEnded, Notifications::Ideas::Cleanup
  end
end
