# frozen_string_literal: true

class DigestBuilder
  include Digests::DailyMorning

  attr_reader :user, :tasks, :events, :ideas, :birthdays

  def initialize(user_id)
    @user      = User.find(user_id)
    @tasks     = {}
    @events    = {}
    @ideas     = {}
    @birthdays = {}
  end

  def self.build_daily_morning_digest(user_id)
    new(user_id).tap(&:build_daily_morning)
  end
end
