# frozen_string_literal: true

class Control < ApplicationRecord
  belongs_to :division
  belongs_to :manager, class_name: 'User'
end
