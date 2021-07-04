# frozen_string_literal: true

class News < ApplicationRecord
  belongs_to :author, class_name: 'User', optional: true

  enum status: {
    created:   1,
    published: 2,
    archived:  3
  }

  has_one_attached :image

  validates :date, :body, :status, :title, presence: true

  scope :for_portal, -> { where(for_portal: true) }
  scope :for_landing, -> { where(for_landing: true) }
end
