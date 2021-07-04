# frozen_string_literal: true

module Landing
  class Member < ApplicationRecord
    has_one_attached :avatar

    validates :name,
              :position,
              :quote,
              :text,
              :avatar,
              presence: true
  end
end
