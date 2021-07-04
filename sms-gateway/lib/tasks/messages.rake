# frozen_string_literal: true

namespace :messages do
  desc 'Update message statuses by running UpdateMessageStatusesJob'
  task update_statuses: :environment do
    UpdateMessageStatusesJob.perform_later
  end

  desc 'Update all info for all messages'
  task update_all: :environment do
    Provider.all.each do |model|
      ids_to_update = model.messages.ids
      provider      = Providers::Factory.create_by_name(model.name)

      provider.update_message_statuses(ids_to_update)
    end
  end
end
