# frozen_string_literal: true

class Dashboard
  class Create
    include Interactor

    def call
      user      = context.user
      dashboard = context.dashboard = Dashboard.new(user: user)

      return if dashboard.save

      context.fail!(error_message: error_messages_of(dashboard), error_status: :internal_server_error)
    end

    def rollback
      context.dashboard.reload.destroy!
    end
  end
end
