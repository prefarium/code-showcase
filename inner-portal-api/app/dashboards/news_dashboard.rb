# frozen_string_literal: true

require 'administrate/base_dashboard'

class NewsDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    for_landing:      Field::Boolean,
    for_portal:       Field::Boolean,
    author:           Field::BelongsTo,
    image_attachment: Field::HasOne,
    image_blob:       Field::HasOne,
    id:               Field::Number,
    title:            Field::String,
    body:             Field::Text,
    date:             Field::Date,
    created_at:       Field::DateTime,
    updated_at:       Field::DateTime,
    status:           Field::Select.with_options(
      searchable: false,
      collection: ->(field) { field.resource.class.public_send(field.attribute.to_s.pluralize).keys }
    )
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
    status
    date
    author
    for_landing
    for_portal
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    author
    status
    title
    body
    date
    for_landing
    for_portal
  ].freeze

  FORM_ATTRIBUTES = %i[
    status
    title
    body
    date
    for_landing
    for_portal
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(news)
    news.title
  end

  def self.resource_name(_opts)
    'Новости'
  end
end
