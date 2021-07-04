# frozen_string_literal: true

module Admin
  class EventsController < Admin::ApplicationController
    def create
      context   = Event::Assign.call(params_for_creating)
      @resource = context.event

      if context.success?
        redirect_to [namespace, @resource], notice: translate_with_resource('create.success')
      else
        flash.alert = context.error_message
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      end
    end

    def update
      context = Event::Update.call(params_for_updating)

      if context.success?
        redirect_to([namespace, requested_resource], notice: translate_with_resource('update.success'))
      else
        flash.alert = context.error_message
        render :edit,
               locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) },
               status: context.error_status
      end
    end

    def destroy
      context = Event::Cancel.call(event: requested_resource)

      if context.success?
        flash[:notice] = translate_with_resource('destroy.success')
      else
        flash[:error] = context.error_message
      end

      redirect_to action: :index
    end

    private

    def default_sorting_attribute
      :start_time
    end

    def default_sorting_direction
      :asc
    end

    def scoped_resource
      Event.common
    end

    def params_for_creating
      { event_params: resource_params.merge(confirmable: false, status: :common) }
    end

    def params_for_updating
      {
        event:        requested_resource,
        event_params: resource_params
      }
    end
  end
end
