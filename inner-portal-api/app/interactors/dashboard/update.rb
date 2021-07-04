# frozen_string_literal: true

class Dashboard
  class Update
    include Interactor

    def call
      dashboard = context.dashboard
      params    = context.dashboard_params

      context.dashboard_attributes_backup = dashboard.attributes

      return if dashboard.update(params)

      context.fail!(error_message: error_messages_of(dashboard), error_status: :unprocessable_entity)
    end

    def rollback
      context.dashboard.reload.update!(context.dashboard_attributes_backup)
    end
  end
end
