# frozen_string_literal: true

class Event < ApplicationRecord
  self.inheritance_column = 'not_sti'
  acts_as_paranoid

  # ----- Поиск

  include PgSearch::Model
  pg_search_scope :search,
                  against:            %i[title description type_in_russian],
                  associated_against: {
                    author:       %i[first_name last_name middle_name],
                    participants: %i[first_name last_name middle_name]
                  },
                  using:              { tsearch: { dictionary: 'russian' } }

  # ----- Константы

  STATUSES_TO_THUMBS =
    {
      pending:  :none,
      approved: :up,
      denied:   :down
    }.stringify_keys.freeze

  # ----- Енумы

  enum type: {
    scheduled_vacation: 1,
    work_from_home:     2,
    day_off:            3
  }

  enum status: {
    common:   0,
    pending:  1,
    approved: 2,
    denied:   3
  }

  # ----- Ассоциации

  belongs_to :author, class_name: 'User', optional: true

  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, inverse_of: :assigned_events

  # ----- Коллбэки

  # Костыль, чтобы pg_search_scope мог искать по типам
  before_validation :set_type_in_russian

  # ----- Валидации

  validates :type, :type_in_russian, :status, presence: true, if: -> { confirmable }
  validates :title, presence: false, if: -> { confirmable }

  validates :type, :type_in_russian, :status, presence: false, unless: -> { confirmable }
  validates :title, presence: true, unless: -> { confirmable }

  validates :start_time, :end_time, presence: true

  validate :start_time_cannot_be_greater_than_end_time

  # ----- Скоупы

  scope :at_date, ->(date) { in_period(date.beginning_of_day..date.end_of_day) }
  scope :without_private, -> { where(status: nil).or(approved) }
  scope :with_participants, ->(ids) { includes(:participations).where(participations: { participant_id: ids }) }
  scope :processed, -> { approved.or(denied) }

  scope :in_period,
        lambda { |period|
          where(start_time: period)
            .or(where(end_time: period))
            .or(where('start_time <= ? AND end_time >= ?', period.first, period.last))
        }

  # ----- Методы

  alias_attribute :confirmable?, :confirmable
  alias_attribute :canceled?, :deleted?

  # Это будут типы событий, когда я тут всё отрефакторю
  def real_type
    if common?
      :common
    elsif confirmable?
      :confirmable
    elsif participant_ids != [author_id]
      :not_confirmable
    else
      :private
    end
  end

  # Дата/даты провеления события
  def dates
    if start_time.to_date == end_time.to_date
      time_to_string(start_time)
    else
      "#{time_to_string start_time} - #{time_to_string end_time}"
    end
  end

  private

  def set_type_in_russian
    self.type_in_russian = Event.human_attribute_name("type.#{type}") if type
  end

  def start_time_cannot_be_greater_than_end_time
    return if !start_time || !end_time || start_time <= end_time

    errors.add(:start_time, "не может быть больше, чем #{Event.human_attribute_name(:end_time).downcase}")
  end

  def time_to_string(time)
    "#{time.day} #{I18n.t('date.abbr_month_names')[time.month]}"
  end
end
