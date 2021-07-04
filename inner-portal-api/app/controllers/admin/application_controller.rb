# frozen_string_literal: true

module Admin
  class ApplicationController < Administrate::ApplicationController
    http_basic_authenticate_with name: ENV.fetch('ADMIN_EMAIL'), password: ENV.fetch('ADMIN_PASSWORD')

    def create
      @resource = resource_class.new(resource_params)
      authorize_resource(@resource)

      if before_create && before_save && @resource.save
        after_create
        after_save
        redirect_to [namespace, @resource], notice: translate_with_resource('create.success')
      else
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      end
    end

    def update
      @resource = requested_resource

      if before_update && before_save && @resource.update(resource_params)
        after_update
        after_save
        redirect_to [namespace, @resource], notice: translate_with_resource('update.success')
      else
        render :edit, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      end
    end

    private

    def find_resource(param)
      scoped_resource.unscoped.find(param)
    end

    def resource_params
      super.tap do |params|
        params.each_pair { |k, v| params[k] = nil if v.blank? }
      end
    end

    def before_save
      true
    end

    def before_create
      true
    end

    def before_update
      true
    end

    def after_save; end

    def after_create; end

    def after_update; end
  end
end
