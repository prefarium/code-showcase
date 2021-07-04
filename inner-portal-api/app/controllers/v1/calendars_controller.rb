# frozen_string_literal: true

module V1
  class CalendarsController < APIController
    def show
      return hide_requested_section unless EventPolicy.can(current_user).access?(user)

      events = Events::CollectionForCalendarQuery.call(
        permit_params(:for_division, :filter, :common).merge(current_user:  current_user,
                                                             user:          user,
                                                             range_of_days: range_of_days)
      )

      context = Calendar::Fill.call(events: events, range_of_days: range_of_days)

      render json: context.calendar
    end

    private

    def range_of_days
      month = params[:month]&.to_i || Date.current.month
      year  = params[:year]&.to_i || Date.current.year

      period_start = Date.new(year, month, 1)
      period_end   = period_start.end_of_month

      @range_of_days ||= period_start..period_end
    end
  end
end
