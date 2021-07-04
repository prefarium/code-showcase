# frozen_string_literal: true

module V1
  class BotsController < APIController
    skip_before_action :authorize_by_access_header!, only: :webhook
    before_action :authorize_bot, only: :webhook

    rescue_from BotUnauthorized, with: :bot_unauthorized

    def webhook
      context = TelegramBot::ProcessDataFromWebhook.call(webhook_params)

      context.bot_responses&.each do |text|
        TelegramBot::SendMessage.call(chat_id: params[:message][:chat][:id], text: text)
      end
    end

    def send_invites
      return render_error(I18n.t('errors.bot.link_not_present'), :unprocessable_entity) if params[:link].blank?
      return render_error(I18n.t('errors.bot.link_invalid'), :unprocessable_entity) unless link_valid?

      users        = User.find(params[:user_ids])
      birthday_man = User.find(params[:birthday_man_id])

      unless BotPolicy.can(current_user).celebrate_birthday_of?(birthday_man)
        return render_error(I18n.t('errors.bot.birthday_man_not_a_colleague'), :forbidden)
      end

      unless BotPolicy.can(current_user).invite?(users)
        return render_error(I18n.t('errors.bot.users_cannot_be_invited'), :forbidden)
      end

      User.where(id: params[:user_ids]).includes(:telegram_account).each do |user|
        if user.telegram_account&.chat_id
          TelegramBot::SendMessage.call(
            chat_id: user.telegram_account.chat_id,
            text:    I18n.t('bot_messages.birthday_is_coming',
                            birthday_man_name: birthday_man.last_and_first_names,
                            link:              params[:link])
          )
        else
          BirthdayMailer.invite(user.id, birthday_man.id, params[:link]).deliver_later
        end
      end
    end

    private

    def authorize_bot
      raise BotUnauthorized unless params[:token] == ENV['WEBHOOK_TOKEN']
    end

    def link_valid?
      params[:link].match?(%r{\A(https://)?t.me/joinchat/[-\w]+\z})
    end

    def webhook_params
      {
        telegram_account_params: {
          chat_id:  params[:message][:chat][:id],
          username: params[:message][:chat][:username]
        }
      }
    end
  end
end
