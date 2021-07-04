# frozen_string_literal: true

require 'administrate/base_dashboard'

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    votes:                Field::HasMany,
    avatar_attachment:    Field::HasOne,
    avatar_blob:          Field::HasOne,
    paper_division:       Field::BelongsTo,
    division:             Field::BelongsTo,
    position:             Field::BelongsTo,
    assigned_tasks:       Field::HasMany,
    created_tasks:        Field::HasMany,
    participations:       Field::HasMany,
    assigned_events:      Field::HasMany,
    created_events:       Field::HasMany,
    created_ideas:        Field::HasMany,
    pins:                 Field::HasMany,
    pinned_ideas:         Field::HasMany,
    news:                 Field::HasMany,
    petitions:            Field::HasMany,
    dashboard:            Field::HasOne,
    controls:             Field::HasMany,
    controlled_divisions: Field::HasMany,
    id:                   Field::Number,
    first_name:           Field::String,
    last_name:            Field::String,
    middle_name:          Field::String,
    email:                Field::String,
    phone:                Field::String,
    password_digest:      Field::String,
    actual_position:      Field::String,
    reset_token:          Field::String,
    birth_date:           Field::Date,
    created_at:           Field::DateTime,
    updated_at:           Field::DateTime,
    role:                 Field::Select.with_options(
      searchable: false,
      collection: ->(field) { field.resource.class.public_send(field.attribute.to_s.pluralize).keys }
    )
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    last_name
    first_name
    middle_name
    division
    actual_position
    role
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    last_name
    first_name
    middle_name
    email
    phone
    birth_date
    division
    paper_division
    position
    actual_position
    role
  ].freeze

  FORM_ATTRIBUTES = %i[
    last_name
    first_name
    middle_name
    email
    phone
    birth_date
    division
    paper_division
    position
    actual_position
    role
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(resource)
    resource.full_name
  end

  def self.resource_name(_opts)
    'Пользователи'
  end
end
