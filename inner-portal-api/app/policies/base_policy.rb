# frozen_string_literal: true

class BasePolicy
  attr_reader :checked_user

  def initialize(checked_user)
    @checked_user = checked_user
  end

  class << self
    alias can new
  end
end
