# frozen_string_literal: true

require 'administrate/base_dashboard'

class FeedbackDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    file_attachment: Field::HasOne,
    file_blob:       Field::HasOne,
    id:              Field::Number,
    body:            Field::Text.with_options(truncate: 25),
    author:          Field::BelongsTo,
    created_at:      Field::DateTime,
    updated_at:      Field::DateTime,
    status:          Field::Select.with_options(
      searchable: false,
      collection: ->(field) { field.resource.class.public_send(field.attribute.to_s.pluralize).keys }
    )
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    created_at
    status
    author
    body
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    body
    author
    status
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    status
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(feedback)
    "Обратная связь - #{feedback.author.full_name}"
  end

  def self.resource_name(_opts)
    'Обратная связь'
  end
end
