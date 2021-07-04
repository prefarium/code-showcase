# frozen_string_literal: true

module Providers
  class TeraSms
    module Constants
      API_RESPONSE_STATUSES = # Returns a response status by its meaning
        {
          success: 0
        }.freeze

      # rubocop:disable Layout/MultilineMethodCallIndentation
      # Cop is triggered incorrectly
      MESSAGE_STATUSES = # Translate a TeraSms message status into our own
        {
          0   => :left,
          1   => :sent,
          12  => :delivered,
          13  => :expired,
          15  => :failed,
          17  => :unknown,
          18  => :rejected,
          255 => :error
        }.tap { |statuses| statuses.default = :undefined }
         .freeze

      OPERATORS = {
        'Россия МТС':                :mts,
        'Россия Билайн':             :beeline,
        'Россия Мегафон':            :megafon,
        'Россия Теле2 (Ростелеком)': :tele2,
        'Россия Yota':               :yota
      }.tap { |operators| operators.default = :other }
       .stringify_keys
      # rubocop:enable Layout/MultilineMethodCallIndentation

      private_constant :API_RESPONSE_STATUSES
      private_constant :MESSAGE_STATUSES
      private_constant :OPERATORS
    end
  end
end
