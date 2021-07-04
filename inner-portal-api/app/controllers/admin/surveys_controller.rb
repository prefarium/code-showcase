# frozen_string_literal: true

module Admin
  class SurveysController < Admin::ApplicationController
    def index
      @show_archive            = params[:show_archive] == 'true'
      @switch_to_archive_title = if @show_archive
                                   'Показать готовые опросы'
                                 else
                                   'Показать опросы в архиве'
                                 end
      super
    end

    def create
      context   = if resource_params[:status] == 'current'
                    Survey::CreateAndPublish.call(survey_params: resource_params)
                  else
                    Survey::Create.call(survey_params: resource_params)
                  end

      @resource = context.survey

      if context.success?
        redirect_to [namespace, @resource], notice: translate_with_resource('create.success')
      else
        flash.alert = context.error_message
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      end
    end

    def update
      context = if resource_params[:status] == 'current'
                  Survey::UpdateAndPublish.call(survey: requested_resource, survey_params: resource_params)
                else
                  Survey::Update.call(survey: requested_resource, survey_params: resource_params)
                end

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
      @show_archive ? Survey.archived : Survey.not_archived
    end
  end
end
