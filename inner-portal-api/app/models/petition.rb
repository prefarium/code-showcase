# frozen_string_literal: true

class Petition < ApplicationRecord
  enum status: {
    created:  1,
    approved: 2,
    denied:   3
  }

  belongs_to :author, class_name: 'User'

  validates :title, :body, :status, presence: true
  validates :denial_reason, absence: true, unless: -> { denied? }
end
