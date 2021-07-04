# frozen_string_literal: true

module V1
  class HeadersController < APIController
    def notification_numbers
      render json: {
        birthdays: birthdays_number,
        events:    events_number,
        tasks:     current_user.assigned_tasks.count
      }
    end

    private

    def events_number
      Events::FilteredCollectionQuery.call(
        current_user: current_user,
        user:         current_user,
        for_division: false,
        filter:       'assigned',
        common:       false,
        date:         Date.current
      ).count
    end

    def birthdays_number
      Users::Birthdays::UpcomingQuery.call(
        {
          users:          current_user.colleagues,
          number_of_days: params[:number_of_days]&.to_i
        }.compact
      ).size
    end
  end
end
