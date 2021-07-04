# frozen_string_literal: true

class Provider < ApplicationRecord
  has_many :keys, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :users, through: :keys
end
