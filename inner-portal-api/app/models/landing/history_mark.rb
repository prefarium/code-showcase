# frozen_string_literal: true

module Landing
  class HistoryMark < ApplicationRecord
    validates :year, :text, presence: true
  end
end
