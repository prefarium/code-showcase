# frozen_string_literal: true

require 'administrate/base_dashboard'

class SurveyDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:         Field::Number,
    name:       Field::String,
    link:       Field::String,
    title:      Field::String,
    body:       Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    status:     Field::Select.with_options(
      searchable: false,
      collection: ->(field) { field.resource.class.public_send(field.attribute.to_s.pluralize).keys }
    )
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    name
    link
    status
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    name
    link
    title
    body
    status
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    link
    title
    body
    status
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(surveys)
    surveys.title
  end

  def self.resource_name(_opts)
    'Опросы'
  end
end
