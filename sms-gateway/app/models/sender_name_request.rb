# frozen_string_literal: true

class SenderNameRequest < ApplicationRecord
  belongs_to :user
  belongs_to :provider

  enum status: {
    pending:  0,
    approved: 1,
    denied:   2
  }
end
