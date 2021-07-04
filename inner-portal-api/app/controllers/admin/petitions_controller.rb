# frozen_string_literal: true

module Admin
  class PetitionsController < Admin::ApplicationController
    def index
      @show_archive            = params[:show_archive] == 'true'
      @switch_to_archive_title = if @show_archive
                                   'Показать обращения, ожидающие обработки'
                                 else
                                   'Показать обработанные обращение'
                                 end
      super
    end

    def update
      context = Petition::ChangeStatus.call(petition: requested_resource, petition_params: resource_params)

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

    def default_sorting_attribute
      :created_at
    end

    def default_sorting_direction
      :asc
    end

    def scoped_resource
      @show_archive ? Petition.not_created : Petition.created
    end
  end
end
