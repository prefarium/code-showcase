# frozen_string_literal: true

module Calendar
  class Fill
    include Interactor

    def call
      events        = context.events
      range_of_days = context.range_of_days
      calendar      = context.calendar = {}

      day_defaults = { event: 0 }.stringify_keys
      Event.types.each_key { |key| day_defaults[key] = 0 }

      range_of_days.each do |date|
        day_number           = date.day
        calendar[day_number] = day_defaults.dup

        events.each do |event|
          next unless (event.start_time.to_date..event.end_time.to_date).cover?(date)

          event.type.present? ? calendar[day_number][event.type] += 1 : calendar[day_number]['event'] += 1
        end
      end
    end
  end
end
