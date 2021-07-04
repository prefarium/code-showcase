# frozen_string_literal: true

class BotPolicy < BasePolicy
  def invite?(users)
    (users - checked_user.division.employees).empty?
  end

  def celebrate_birthday_of?(user)
    checked_user.colleague_of?(user)
  end
end
