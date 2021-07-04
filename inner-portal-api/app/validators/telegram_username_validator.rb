# frozen_string_literal: true

class TelegramUsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if /\A\w{5,}\z/.match?(value) && !/\A_|_\z|_{2,}/.match?(value)

    record.errors.add attribute, I18n.t('errors.validations.incorrect_telegram_username')
  end
end
