# frozen_string_literal: true

class Pin < ApplicationRecord
  belongs_to :idea
  belongs_to :pinner, class_name: 'User'
end
