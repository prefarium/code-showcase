# frozen_string_literal: true

module V1
  class UsersController < APIController
    include Pagination

    def index
      users = Users::FilteredCollectionQuery.call(filtered_collection_params)
      users = users.search(search_query).pg_search_distinct if search_query.present?
      users = users.includes(:division, :position).with_attached_avatar

      render json: collection_for_rendering(users, view: :index).merge(
        total_users:      User.count,
        total_colleagues: current_user.division.employees.count,
        division_name:    Division.find_by(id: params[:division_id])&.name
      )
    end

    def show
      user = User.find(params[:id])
      render json: UserSerializer.render_as_hash(user, view: :show)
    end

    private

    def filtered_collection_params
      permit_params(:division_id, :filter, :sorting_direction, :sorting_field)
    end
  end
end
