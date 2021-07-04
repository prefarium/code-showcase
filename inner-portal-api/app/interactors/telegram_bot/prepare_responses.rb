# frozen_string_literal: true

module TelegramBot
  class PrepareResponses
    include Interactor

    def call
      new_attributes = context.new_attributes
      old_attributes = context.old_attributes
      bot_responses  = context.bot_responses ||= []

      return unless new_attributes && old_attributes

      if new_attributes[:username] != old_attributes[:username]
        bot_responses << I18n.t('bot_messages.username_changed')
      elsif new_attributes[:chat_id] != old_attributes[:chat_id]
        bot_responses << I18n.t('bot_messages.chat_id_saved')
      end
    end
  end
end
