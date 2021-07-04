# frozen_string_literal: true

module V1
  module Current
    class DashboardsController < APIController
      def show
        render json: DashboardSerializer.render_as_hash(current_user.dashboard)
      end

      def update
        context = Dashboard::Update.call(dashboard: current_user.dashboard, dashboard_params: dashboard_params)

        render_error_from_context(context) if context.failure?
      end

      private

      def dashboard_params
        permit_params(Dashboard.setting_keys)
      end
    end
  end
end
