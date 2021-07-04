# frozen_string_literal: true

class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :messages, as: :author, dependent: :destroy
end
