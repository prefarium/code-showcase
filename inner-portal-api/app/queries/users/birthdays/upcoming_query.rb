# frozen_string_literal: true

module Users
  module Birthdays
    module UpcomingQuery
      # Находит number_of_birthdays людей с ближайшими днями рождениями
      def self.call(users:, number_of_birthdays: 6)
        data = users.pluck(:id, :birth_date)

        data = data.reduce([]) do |acc, el|
          acc << [el.first, el.last.change(year: Date.current.year)]
          acc << [el.first, el.last.change(year: Date.current.year + 1)]
        end

        data.sort_by!(&:last)
        idx = data.find_index { |el| el.last >= Date.current }
        ids = data[idx...(idx + number_of_birthdays)].map(&:first)
        User.where(id: ids).order_by_birthday
      end
    end
  end
end
