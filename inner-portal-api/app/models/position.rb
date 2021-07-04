# frozen_string_literal: true

class Position < ApplicationRecord
  has_many :employees, class_name: 'User', dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
