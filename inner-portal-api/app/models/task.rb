# frozen_string_literal: true

class Task < ApplicationRecord
  acts_as_paranoid

  include PgSearch::Model
  pg_search_scope :search,
                  against:            %i[title description],
                  associated_against: {
                    author:   %i[first_name last_name middle_name],
                    assignee: %i[first_name last_name middle_name]
                  },
                  using:              { tsearch: { dictionary: 'russian' } }

  enum status: {
    rejected:    0,
    assigned:    1,
    in_progress: 2,
    paused:      3,
    completed:   4
  }

  belongs_to :assignee, class_name: 'User'
  belongs_to :author, class_name: 'User'

  has_many :notifications, as: :notifiable, dependent: :destroy

  # Коллбэк вместо действия в интеракторе,
  #   так как это поле всегда должно быть автоматически заполняемым, как created_at и updated_at
  before_validation :set_status_changed_timestamp

  validates :reject_reason, presence: true, if: -> { rejected? }
  validates :reject_reason, absence: true, unless: -> { rejected? }
  validates :title, :status, presence: true
  validates :status_changed_at, presence: true, unless: -> { assigned? }

  scope :archived, -> { only_deleted }
  scope :ended, -> { completed.or(rejected) }

  alias_attribute :canceled?, :deleted?

  private

  def set_status_changed_timestamp
    self.status_changed_at = Time.current if status_changed? && !assigned?
  end
end
