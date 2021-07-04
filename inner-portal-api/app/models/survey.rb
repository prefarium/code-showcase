# frozen_string_literal: true

class Survey < ApplicationRecord
  enum status: {
    ready:    1,
    current:  2,
    archived: 3
  }

  before_validation :normalize_link

  validates :name, :title, :body, :status, presence: true
  validates :link, presence: true, link: true

  private

  def normalize_link
    self.link = "http://#{link}" unless link.match? %r{^https?://}
  end
end
