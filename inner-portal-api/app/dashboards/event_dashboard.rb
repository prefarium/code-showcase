# frozen_string_literal: true

require 'administrate/base_dashboard'

class EventDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    author:         Field::BelongsTo.with_options(class_name: 'User'),
    participations: Field::HasMany,
    participants:   Field::HasMany.with_options(class_name: 'User'),
    id:             Field::Number,
    confirmable:    Field::Boolean,
    title:          Field::String,
    start_time:     Field::DateTime.with_options(format: '%d.%m.%Y %H:%M'),
    end_time:       Field::DateTime.with_options(format: '%d.%m.%Y %H:%M'),
    description:    Field::Text,
    author_id:      Field::Number,
    created_at:     Field::DateTime,
    updated_at:     Field::DateTime,

    type:           Field::Select.with_options(
      searchable: false,
      collection: ->(field) { field.resource.class.public_send(field.attribute.to_s.pluralize).keys }
    ),

    status:         Field::Select.with_options(
      searchable: false,
      collection: ->(field) { field.resource.class.public_send(field.attribute.to_s.pluralize).keys }
    )
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
    start_time
    end_time
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    title
    start_time
    end_time
    description
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
    start_time
    end_time
    description
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(event)
    event.title
  end

  def self.resource_name(_opts)
    'События'
  end
end
