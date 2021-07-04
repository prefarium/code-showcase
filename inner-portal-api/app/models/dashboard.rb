# frozen_string_literal: true

class Dashboard < ApplicationRecord
  belongs_to :user

  class << self
    # Возвращает список доступных настроек
    def setting_keys
      (column_names - ignored_keys).map(&:to_sym)
    end

    private

    def ignored_keys
      %w[id user_id created_at updated_at]
    end
  end
end
