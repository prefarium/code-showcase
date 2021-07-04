# frozen_string_literal: true

module Admin
  class DocumentsController < Admin::ApplicationController
    def create
      context   = Document::Create.call(params_for_creating)
      @resource = context.document

      if context.success?
        redirect_to [namespace, @resource], notice: translate_with_resource('create.success')
      else
        flash.alert = context.error_message
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      end
    end

    def update
      context = Document::Update.call(params_for_updating)

      if context.success?
        redirect_to [namespace, requested_resource], notice: translate_with_resource('update.success')
      else
        flash.alert = context.error_message
        render :edit, locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) }
      end
    end

    private

    def params_for_creating
      {
        document_params: resource_params,
        file:            params.dig(:document, :file)
      }
    end

    def params_for_updating
      {
        document:        requested_resource,
        document_params: resource_params,
        file:            params.dig(:document, :file)
      }
    end
  end
end
