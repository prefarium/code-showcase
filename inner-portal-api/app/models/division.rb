# frozen_string_literal: true

class Division < ApplicationRecord
  has_many :employees, class_name: 'User', dependent: :restrict_with_error
  has_many :paper_employees,
           class_name:  'User',
           foreign_key: :paper_division_id,
           inverse_of:  :paper_division,
           dependent:   :restrict_with_error

  has_many :ideas, dependent: :destroy
  has_many :controls, dependent: :destroy
  has_many :managers, through: :controls

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def tasks
    Task.where(author_id: employee_ids).or(Task.where(assignee_id: employee_ids))
  end

  def events
    Event.with_participants(employee_ids)
  end

  def head
    managers.find_by(role: :head)
  end
end
