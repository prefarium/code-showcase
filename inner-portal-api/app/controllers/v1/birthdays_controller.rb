# frozen_string_literal: true

module V1
  class BirthdaysController < APIController
    def index
      birthday_mens = Users::Birthdays::InDaysQuery.call(
        permit_params(:month, :day).merge(users: current_user.division.employees)
      )

      birthday_mens = birthday_mens.limit(params[:limit]) if params[:limit]
      birthday_mens = birthday_mens.includes(:position).with_attached_avatar

      render json: UserSerializer.render_as_hash(birthday_mens, view: :birthday)
    end

    def upcoming
      birthday_mens = Users::Birthdays::UpcomingQuery.call(
        {
          users:               current_user.division.employees,
          number_of_birthdays: params[:number_of_birthdays]&.to_i
        }.compact
      )

      birthday_mens = birthday_mens.includes(:position).with_attached_avatar

      render json: UserSerializer.render_as_hash(birthday_mens, view: :birthday)
    end
  end
end
