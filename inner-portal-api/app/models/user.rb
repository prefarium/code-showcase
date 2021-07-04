# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_voter
  has_secure_password

  # ----- Поиск

  include PgSearch::Model
  pg_search_scope :search,
                  against:            %i[first_name last_name middle_name],
                  associated_against: {
                    division: %i[name],
                    position: %i[name]
                  },
                  using:              { tsearch: { dictionary: 'russian' } }

  # ----- Енумы

  BOSS_ROLES = %w[director deputy head].freeze

  enum role: {
    mortal:   1,
    head:     2,
    deputy:   3,
    director: 4
  }

  # ----- Ассоциации

  has_one_attached :avatar

  belongs_to :paper_division, class_name: 'Division'
  belongs_to :division
  belongs_to :position

  # ---------- Задачи

  has_many :assigned_tasks,
           class_name:  'Task',
           foreign_key: :assignee_id,
           dependent:   :destroy,
           inverse_of:  :assignee

  has_many :created_tasks,
           class_name:  'Task',
           foreign_key: :author_id,
           dependent:   :destroy,
           inverse_of:  :author

  # ---------- События

  has_many :participations,
           foreign_key: :participant_id,
           dependent:   :destroy,
           inverse_of:  :participant

  has_many :assigned_events,
           through: :participations,
           source:  :event

  has_many :created_events,
           class_name:  'Event',
           foreign_key: :author_id,
           dependent:   :destroy,
           inverse_of:  :author

  # ---------- Идеи

  has_many :created_ideas,
           class_name:  'Idea',
           foreign_key: :author_id,
           dependent:   :destroy,
           inverse_of:  :author

  has_many :pins,
           foreign_key: :pinner_id,
           dependent:   :destroy,
           inverse_of:  :pinner

  has_many :pinned_ideas,
           through: :pins,
           source:  :idea

  # ---------- Новости

  has_many :news,
           foreign_key: :author_id,
           dependent:   :destroy,
           inverse_of:  :author

  # ---------- Обращения

  has_many :petitions, foreign_key: :author_id, inverse_of: :author, dependent: :destroy

  # ---------- Управление подразделениями

  has_many :controls,
           foreign_key: :manager_id,
           dependent:   :destroy,
           inverse_of:  :manager

  has_many :controlled_divisions,
           through: :controls,
           source:  :division

  # ---------- Обратная связь

  has_many :feedbacks,
           foreign_key: :author_id,
           inverse_of:  :author,
           dependent:   :destroy

  # ---------- Уведомления

  has_many :notifications,
           foreign_key: :recipient_id,
           inverse_of:  :recipient,
           dependent:   :destroy

  # ---------- Различные настройки

  has_one :dashboard, dependent: :destroy
  has_one :telegram_account, dependent: :destroy
  has_one :notification_setting, dependent: :destroy

  # ----- Коллбэки

  before_save :normalize_data

  # ----- Валидации

  validates :birth_date, :first_name, :last_name, :role, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  # ----- Скоупы

  scope :order_by_birthday,
        lambda {
          select('*, EXTRACT(MONTH from birth_date) * 100 + EXTRACT(DAY from birth_date) as flag')
            .unscope(:order)
            .order(flag: :asc)
        }

  scope :order_by_name,
        lambda { |sorting_direction|
          order(last_name: sorting_direction, first_name: sorting_direction, middle_name: sorting_direction)
        }

  # ----- Методы

  alias_attribute :all_events, :events
  alias_attribute :all_tasks, :tasks

  def events
    assigned_events.or(created_events)
  end

  def tasks
    assigned_tasks.or(created_tasks)
  end

  # ----- Ролевая система

  # У каждого юзера может быть только 1 начальник
  def boss
    case role
    when 'director'
      nil
    when 'deputy'
      User.find_by(role: :director)
    when 'head'
      division.managers.find_by(role: %i[deputy director])
    else
      User.find_by(role: :head, division_id: division_id)
    end
  end

  def boss_of?(user)
    id == user.boss&.id
  end

  def boss?
    BOSS_ROLES.include?(role)
  end

  def colleagues
    division.employees.where.not(id: id)
  end

  def colleague_of?(user)
    colleagues.ids.include?(user.id)
  end

  # Список тех, для кого юзер может создавать задачи и события (сам юзер тоже включен в этот список)
  def possible_assignees
    case role
    when 'director'
      User.where(division_id: division_id).or(User.head.where(division_id: controlled_division_ids))
    when 'deputy'
      User.deputy.or(User.head.where(division_id: controlled_division_ids))
    when 'head'
      User.where(division_id: controlled_division_ids)
    else
      User.mortal.where(division_id: division_id)
    end
  end

  # ----- Комбинации слов в имени

  def first_and_middle_names
    "#{first_name} #{middle_name}".strip
  end

  def full_name
    "#{last_name} #{first_name} #{middle_name}".strip
  end

  def last_and_first_names
    "#{last_name} #{first_name}"
  end

  def short_name
    "#{last_name} #{first_name.first}." + (middle_name ? " #{middle_name.first}." : '')
  end

  # -----

  def voting_result_for(idea)
    return if voted_as_when_voted_for(idea).nil?

    liked?(idea) ? :like : :dislike
  end

  private

  def normalize_data
    email.downcase! if email_changed?
    self.phone       = phone.gsub(/\D/, '').last(10) if phone_changed?
    self.first_name  = first_name.mb_chars.titleize.to_s if first_name_changed?
    self.last_name   = last_name.mb_chars.titleize.to_s if last_name_changed?
    self.middle_name = middle_name.mb_chars.titleize.to_s if middle_name_changed?
  end
end
