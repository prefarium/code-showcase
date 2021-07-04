# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern

  def page
    @page ||= params[:page].presence&.to_i || 1
  end

  def entities_on_page
    @entities_on_page ||= params[:entities_on_page].presence&.to_i || ENV.fetch('ENTITIES_ON_PAGE', 10)
  end

  def paginate(resources)
    resources.page(page).per(entities_on_page)
  end

  def total_pages(resources)
    (resources.count / entities_on_page.to_f).ceil
  end

  def collection_for_rendering(resources, **serializer_options)
    resources_class = resources.respond_to?(:klass) ? resources.klass : resources.first&.class
    return empty_collection if resources_class.nil?

    serializer = serializer_options[:serializer] || "#{resources_class}Serializer".constantize

    {
      resources:       serializer.render_as_hash(paginate(resources), serializer_options),
      total_resources: resources.count,
      total_pages:     total_pages(resources)
    }
  end

  def empty_collection
    {
      resources:       [],
      total_resources: 0,
      total_pages:     0
    }
  end
end
