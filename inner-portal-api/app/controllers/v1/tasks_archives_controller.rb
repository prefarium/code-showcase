# frozen_string_literal: true

module V1
  class TasksArchivesController < APIController
    include Pagination
    include Notifiable

    before_action :set_task, only: :show
    after_action(only: :show) { mark_notification_as_read(@task) }

    def index
      tasks = Tasks::FilteredCollectionQuery.call(
        permit_params(:filter, :sorting_direction, :sorting_field).merge(current_user: current_user,
                                                                         user:         current_user)
      )

      tasks = tasks.archived
      tasks = tasks.search(search_query).pg_search_distinct if search_query.present?
      tasks = tasks.includes(:author, :assignee)

      render json: collection_for_rendering(tasks, view: :index, current_user: current_user)
    end

    def show
      unless TaskPolicy.can(current_user).read?(@task)
        return render_error(I18n.t('errors.tasks.forbidden_to_read'), :forbidden)
      end

      render json: TaskSerializer.render_as_hash(@task, view: :show, current_user: current_user)
    end

    private

    def set_task
      @task = Task.archived.find(params[:id])
    end
  end
end
