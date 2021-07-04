# frozen_string_literal: true

class Participation < ApplicationRecord
  acts_as_paranoid

  belongs_to :event
  belongs_to :participant, class_name: 'User'
end
