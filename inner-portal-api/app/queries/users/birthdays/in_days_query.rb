# frozen_string_literal: true

module Users
  module Birthdays
    module InDaysQuery
      def self.call(users:, month: Date.current.month, day: nil)
        birthday_mens = users.where('EXTRACT(MONTH FROM birth_date) = ?', month)

        if day.present?
          birthday_mens = case day
                          when Integer
                            birthday_mens.and users.where('EXTRACT(DAY FROM birth_date) = ?', day)
                          when Range
                            birthday_mens.and users.where('EXTRACT(DAY FROM birth_date) BETWEEN ? AND ?',
                                                          day.first,
                                                          day.last(1).last)
                          else
                            raise IncorrectQueryParameter,
                                  I18n.t('errors.birthdays.unexpected_day_class', class_name: day.class.name)
                          end
        end

        birthday_mens.order_by_birthday
      end
    end
  end
end
