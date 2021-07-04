# frozen_string_literal: true

module V1
  module Current
    class UsersController < APIController
      def show
        render json: UserSerializer.render_as_hash(current_user, view: :show_for_current_user)
      end
    end
  end
end
