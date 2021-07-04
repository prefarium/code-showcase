# frozen_string_literal: true

class Feedback < ApplicationRecord
  enum status: {
    new_one:  1,
    resolved: 2
  }

  has_one_attached :file
  belongs_to :author, class_name: 'User'

  validates :body, :status, presence: true
end
