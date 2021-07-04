# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Нельзя просто так взять и применить .distinct к результатам поиска pg_search_scope
  # https://github.com/Casecommons/pg_search/issues/238#issuecomment-543702501
  scope :pg_search_distinct,
        -> { klass.is_a?(User) ? reorder('').order_by_name.distinct : reorder(created_at: :desc).distinct }
end

# Последовательность кода в моделях:
# ----- Глобальные настройки
# ----- Подключение модулей
# ----- Константы
# ----- Енумы
# ----- Ассоциации
# ----- Коллбэки
# ----- Валидации
# ----- Скоупы
# ----- Глобальный поиск
# ----- Методы
