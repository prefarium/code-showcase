# frozen_string_literal: true

module LinkGenerator
  BASE_URL  = ENV.fetch('BASE_URL')
  ADMIN_URL = ENV.fetch('ADMIN_URL')

  def self.task(id, absolute_link: true)
    "#{BASE_URL if absolute_link}/tasks/#{id}"
  end

  def self.archived_task(id, absolute_link: true)
    "#{BASE_URL if absolute_link}/tasks/archived/#{id}"
  end

  def self.event(id, absolute_link: true)
    "#{BASE_URL if absolute_link}/events/#{id}"
  end

  def self.idea(id, absolute_link: true)
    "#{BASE_URL if absolute_link}/ideas/#{id}"
  end

  def self.petition(id)
    "#{ADMIN_URL}/petitions/#{id}"
  end
end
