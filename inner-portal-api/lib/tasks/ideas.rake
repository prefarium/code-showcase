# frozen_string_literal: true

namespace :ideas do
  desc 'Закрывает голосование за те идеи, чьё время пришло'
  task(end_voting: :environment) { Ideas::EndVotingJob.perform_later }
end
