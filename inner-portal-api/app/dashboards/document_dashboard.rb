# frozen_string_literal: true

require 'administrate/base_dashboard'

class DocumentDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    file_attachment: Field::HasOne,
    file_blob:       Field::HasOne,
    id:              Field::Number,
    name:            Field::String,
    created_at:      Field::DateTime,
    updated_at:      Field::DateTime.with_options(format: '%d.%m.%Y %H:%M')
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    name
    updated_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    name
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(document)
    document.name
  end

  def self.resource_name(_opts)
    'Документы'
  end
end
