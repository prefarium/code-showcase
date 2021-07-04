# frozen_string_literal: true

module Providers
  class SmsCenter
    module Constants
      # rubocop:disable Layout/MultilineMethodCallIndentation
      # Cop is triggered incorrectly
      MESSAGE_STATUSES = # Translate a TeraSms message status into our own
        {
          -1 => :left,
          0  => :sent,
          1  => :delivered,
          3  => :expired,
          20 => :failed,
          23 => :error,
          17 => :unknown,
          32 => :rejected
        }.tap { |statuses| statuses.default = :undefined }
         .freeze

      # TODO: fill up the list
      #   Имя оператора приходит в ответе в закодированом виде
      #   Например, МТС выглядит как \xCC\xD2\xD1 (кодировка CP866)
      #   У меня не получилось перекодировать это в UTF-8, потому пока оставлю данный хэш пустым
      # OPERATORS =
      #   {
      #     'МТС':     :mts,
      #     'Билайн':  :beeline,
      #     'Мегафон': :megafon,
      #     'Теле2':   :tele2,
      #     'YOTA':    :yota
      #   }.tap { |operators| operators.default = :other }
      #    .stringify_keys
      # rubocop:enable Layout/MultilineMethodCallIndentation

      # Заглушка, которая на любое имя оператора возвращает nil
      #   Убарть когда хэш выше заработает
      OPERATORS = {}.freeze

      private_constant :MESSAGE_STATUSES
      private_constant :OPERATORS
    end
  end
end
