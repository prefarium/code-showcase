# frozen_string_literal: true

class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    provider_name = Message.where(id: message_id).joins(:provider).pluck('providers.name')[0]
    provider      = Providers::Factory.create_by_name(provider_name)
    provider.send_message(message_id)
  end
end
