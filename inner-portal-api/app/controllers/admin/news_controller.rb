# frozen_string_literal: true

module Admin
  class NewsController < Admin::ApplicationController
    def index
      @show_archive            = params[:show_archive] == 'true'
      @switch_to_archive_title = @show_archive ? 'Вернуться назад' : 'Показать новости в архиве'
      super
    end

    def create
      context   = News::CreateWithImage.call(params_for_creating)
      @resource = context.news

      if context.success?
        redirect_to [namespace, @resource], notice: translate_with_resource('create.success')
      else
        flash.alert = context.error_message
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      end
    end

    def update
      context = News::UpdateWithImage.call(params_for_updating)

      if context.success?
        redirect_to([namespace, requested_resource], notice: translate_with_resource('update.success'))
      else
        flash.alert = context.error_message
        render :edit,
               locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) },
               status: context.error_status
      end
    end

    private

    def params_for_creating
      {
        news_params: resource_params,
        image:       params.dig(:news, :image)
      }
    end

    def params_for_updating
      {
        news:        requested_resource,
        news_params: resource_params,
        image:       params.dig(:news, :image)
      }
    end

    def default_sorting_attribute
      :date
    end

    def default_sorting_direction
      :asc
    end

    def scoped_resource
      @show_archive ? News.archived : News.not_archived
    end

    def after_save
      @resource.image.attach(params.dig(:news, :image)) if params.dig(:news, :image).present?
    end
  end
end
