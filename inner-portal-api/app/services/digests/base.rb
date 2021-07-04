# frozen_string_literal: true

module Digests
  module Base
    private

    def time(hours, method)
      Time.zone.parse "#{hours} #{Date.public_send(method)}"
    end

    def yesterday
      time(16, :yesterday)..time(10, :today)
    end

    def today
      Date.current
    end

    def tomorrow
      Date.tomorrow
    end
  end
end
