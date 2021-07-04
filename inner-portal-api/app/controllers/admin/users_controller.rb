# frozen_string_literal: true

module Admin
  class UsersController < Admin::ApplicationController
    def create
      context   = User::Register.call(params_for_creating)
      @resource = context.user

      if context.success?
        redirect_to [namespace, @resource], notice: translate_with_resource('create.success')
      else
        flash.alert = context.error_message
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      end
    end

    def update
      context = User::UpdateWithAvatar.call(params_for_updating)

      if context.success?
        redirect_to([namespace, requested_resource], notice: translate_with_resource('update.success'))
      else
        flash.alert = context.error_message
        render :edit,
               locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) },
               status: :unprocessable_entity
      end
    end

    private

    def params_for_creating
      {
        user_params: resource_params,
        avatar:      params.dig(:user, :avatar),
        exp_time:    3.days
      }
    end

    def params_for_updating
      {
        user:        requested_resource,
        user_params: resource_params,
        avatar:      params.dig(:user, :avatar)
      }
    end

    def default_sorting_attribute
      :last_name
    end

    def default_sorting_direction
      :asc
    end
  end
end
