# frozen_string_literal: true

class IdeaPolicy < BasePolicy
  def access?(user)
    checked_user.division == user.division
  end

  def read?(idea)
    checked_user.division == idea.division
  end

  def pin?(idea)
    read?(idea)
  end

  def vote?(idea)
    read?(idea)
  end
end
