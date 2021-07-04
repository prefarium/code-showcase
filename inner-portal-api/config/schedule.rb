# frozen_string_literal: true

every :day, at: '00:00 am' do
  rake 'ideas:end_voting'
  rake 'tasks:archive_ended'
  rake 'events:destroy_denied'
end
