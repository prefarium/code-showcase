# frozen_string_literal: true

module Landing
  class ProjectsController < APIController
    def index
      projects = Landing::Project.order(order_number: :asc, created_at: :desc)
      projects = projects.where(show_on_root: true) if params[:show_on_root] == 'true'

      render json: Landing::ProjectSerializer.render(projects)
    end

    def show
      render json: Landing::ProjectSerializer.render(
        Landing::Project.find(params[:id])
      )
    end
  end
end
