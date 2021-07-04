# frozen_string_literal: true

module Landing
  class ProjectGroupsController < APIController
    def index
      render json: Landing::ProjectGroupSerializer.render(
        Landing::ProjectGroup.order(order_number: :asc, created_at: :desc)
      )
    end

    def show
      render json: Landing::ProjectSerializer.render(
        Landing::Project.where(landing_project_group_id: params[:id])
      )
    end
  end
end
