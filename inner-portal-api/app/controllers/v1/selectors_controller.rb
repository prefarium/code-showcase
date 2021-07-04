# frozen_string_literal: true

module V1
  class SelectorsController < APIController
    def event_types
      types = Event.types.keys.map do |k|
        { id: k, name: Event.human_attribute_name("type.#{k}") }
      end

      render json: types
    end

    def possible_assignees
      users = current_user.possible_assignees.order_by_name(:asc)
      render json: UserSerializer.render_as_hash(users, view: :full_name)
    end
  end
end
