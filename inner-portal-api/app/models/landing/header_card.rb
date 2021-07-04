# frozen_string_literal: true

module Landing
  class HeaderCard < ApplicationRecord
    validates :title, :subtitle, presence: true
  end
end
