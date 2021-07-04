# frozen_string_literal: true

class Idea < ApplicationRecord
  acts_as_votable

  include PgSearch::Model
  pg_search_scope :search,
                  against:            %i[title description],
                  associated_against: {
                    author: %i[first_name last_name middle_name]
                  },
                  using:              { tsearch: { dictionary: 'russian' } }

  enum status: {
    active:   1,
    approved: 2,
    denied:   3
  }

  belongs_to :author, class_name: 'User'
  belongs_to :division

  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :pins, dependent: :destroy
  has_many :pinners, through: :pins, inverse_of: :pinned_ideas

  validates :title, :status, :end_date, presence: true

  scope :ended, -> { not_active }
  scope :without_pins_by, ->(user) { where.not(id: user.pins.pluck(:idea_id)) }

  def ended?
    !active?
  end

  def total_likes
    get_likes.count
  end

  def total_dislikes
    get_dislikes.count
  end
end
