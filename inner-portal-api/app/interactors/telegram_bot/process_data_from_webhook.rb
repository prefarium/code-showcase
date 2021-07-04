# frozen_string_literal: true

module TelegramBot
  class ProcessDataFromWebhook
    include Interactor::Organizer

    organize TelegramAccount::Find, TelegramAccount::Update, PrepareResponses
  end
end
