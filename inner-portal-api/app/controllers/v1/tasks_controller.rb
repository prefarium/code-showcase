# frozen_string_literal: true

module V1
  class TasksController < APIController
    include Pagination
    include Notifiable

    before_action :set_task, only: %i[show update update_status destroy]
    after_action(only: :show) do
      mark_notification_as_read(@task)
      update_notification_numbers
    end

    def index
      return hide_requested_section unless TaskPolicy.can(current_user).access?(user)

      tasks = Tasks::FilteredCollectionQuery.call(
        permit_params(:filter, :sorting_direction, :sorting_field).merge(current_user: current_user,
                                                                         user:         user)
      )

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

    def create
      context = Task::Assign.call(
        task_params: permit_params(:title, :deadline, :description)
                       .merge(author:   current_user,
                              assignee: User.find_by(id: params[:assignee_id]))
      )

      render_error_from_context(context) if context.failure?
    end

    def update
      unless TaskPolicy.can(current_user).edit?(@task)
        return render_error(I18n.t('errors.tasks.forbidden_to_update'), :forbidden)
      end

      context = Task::Update.call(task:        @task,
                                  task_params: permit_params(:title, :description, :deadline))

      render_error_from_context(context) if context.failure?
    end

    def update_status
      unless TaskPolicy.can(current_user).change_status?(@task)
        return render_error(I18n.t('errors.tasks.forbidden_to_update'), :forbidden)
      end

      context = Task::ChangeStatus.call(task:        @task,
                                        task_params: permit_params(:status, :reject_reason))

      render_error_from_context(context) if context.failure?
    end

    def destroy
      unless TaskPolicy.can(current_user).delete?(@task)
        return render_error(I18n.t('errors.tasks.forbidden_to_delete'), :forbidden)
      end

      context = Task::Cancel.call(task: @task)

      render_error_from_context(context) if context.failure?
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end
  end
end
