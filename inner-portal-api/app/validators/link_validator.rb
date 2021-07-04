# frozen_string_literal: true

class LinkValidator < ActiveModel::EachValidator
  LINK_REGEXP = %r{
                  \Ahttps?://                  # https:// # http://
                  (www\.)?                     # www.     # --- без www
                  [-\w]{1,256}\.[a-z\d]{1,6}\b # vk.com   # ok.ru
                  ([-\w()@:%+.~#?&/=]*)\z      # /durov   # --- без адреса
                }ix.freeze

  def validate_each(record, attribute, value)
    return if LINK_REGEXP.match?(value)

    record.errors.add attribute, I18n.t('errors.validations.incorrect_format')
  end
end
