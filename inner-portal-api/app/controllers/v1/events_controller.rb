# frozen_string_literal: true

module V1
  class EventsController < APIController
    include Pagination
    include Notifiable

    before_action :set_event, only: %i[show update update_status destroy]
    after_action(only: :show) do
      mark_notification_as_read(@event)
      update_notification_numbers
    end

    def index
      return hide_requested_section unless EventPolicy.can(current_user).access?(user)

      events = Events::FilteredCollectionQuery.call(
        permit_params(:for_division, :filter, :common).merge(
          { current_user: current_user,
            user:         user,
            date:         params[:date]&.to_date }.compact
        )
      )

      events = if search_query.present?
                 events.search(search_query).pg_search_distinct
               else
                 events.distinct
               end

      events = events.includes(:author)

      render json: collection_for_rendering(events, view: :index, current_user: current_user)
    end

    def waiting_for_confirmation
      return hide_requested_section unless current_user.boss?

      events = Event.includes(:author)
                    .where(author: { division_id: current_user.controlled_division_ids })
                    .where.not(author: { id: current_user.id })
                    .pending
                    .order(created_at: :desc)

      render json: collection_for_rendering(events, view: :for_notification_center, current_user: current_user)
    end

    def processed
      return hide_requested_section unless current_user.boss?

      events = Event.includes(:author)
                    .where(author: { division_id: current_user.controlled_division_ids })
                    .where.not(author: { id: current_user.id })
                    .processed
                    .order(created_at: :desc)

      render json: collection_for_rendering(events, view: :for_notification_center, current_user: current_user)
    end

    def show
      unless EventPolicy.can(current_user).read?(@event)
        return render_error(I18n.t('errors.events.forbidden_to_read'), :forbidden)
      end

      render json: EventSerializer.render_as_hash(@event, view: :show, current_user: current_user)
    end

    def create
      context = Event::Assign.call(
        event_params:    permit_params(:confirmable, :type, :title, :description, :start_time, :end_time)
                           .merge(author: current_user),
        for_division:    params[:for_division],
        participant_ids: params[:participant_ids]
      )

      render_error_from_context(context) if context.failure?
    end

    def update
      unless EventPolicy.can(current_user).edit?(@event)
        return render_error(I18n.t('errors.events.forbidden_to_update'), :forbidden)
      end

      context = Event::Update.call(event:        @event,
                                   event_params: permit_params(:title, :description))

      render_error_from_context(context) if context.failure?
    end

    def update_status
      unless EventPolicy.can(current_user).change_status?(@event)
        return render_error(I18n.t('errors.events.forbidden_to_update'), :forbidden)
      end

      context = Event::ChangeStatus.call(event:        @event,
                                         event_params: permit_params(:status))

      render_error_from_context(context) if context.failure?
    end

    def destroy
      unless EventPolicy.can(current_user).delete?(@event)
        return render_error(I18n.t('errors.events.forbidden_to_delete'), :forbidden)
      end

      context = Event::Cancel.call(event: @event)

      render_error_from_context(context) if context.failure?
    end

    private

    def set_event
      @event = Event.with_deleted.find(params[:id])
    end
  end
end
