# frozen_string_literal: true

require 'administrate/base_dashboard'

class PetitionDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    author:        Field::BelongsTo,
    id:            Field::Number,
    title:         Field::String,
    body:          Field::Text,
    denial_reason: Field::Text,
    created_at:    Field::DateTime,
    updated_at:    Field::DateTime,
    status:        Field::Select.with_options(
      searchable: false,
      collection: ->(field) { field.resource.class.public_send(field.attribute.to_s.pluralize).keys }
    )
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
    author
    status
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    author
    title
    body
    status
    denial_reason
  ].freeze

  FORM_ATTRIBUTES = %i[
    status
    denial_reason
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(petition)
    petition.title
  end

  def self.resource_name(_opts)
    'Обращения'
  end
end
