# frozen_string_literal: true

module V1
  module Authentication
    class RefreshController < APIController
      skip_before_action :authorize_by_access_header!
      before_action :authorize_by_refresh_header!

      def create
        render json: SessionGenerator.new(current_user).session.refresh(found_token)
      end
    end
  end
end
