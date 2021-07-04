# frozen_string_literal: true

module V1
  module Current
    class AvatarsController < APIController
      def update
        context = User::UpdateAvatar.call(user: current_user, avatar: params[:avatar])

        return render_error_from_context(context) if context.failure?

        render json: UserSerializer.render_as_hash(current_user, view: :avatar)
      end
    end
  end
end
