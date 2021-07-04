# frozen_string_literal: true

require 'administrate/base_dashboard'

class DivisionDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    employees:       Field::HasMany,
    paper_employees: Field::HasMany,
    ideas:           Field::HasMany,
    controls:        Field::HasMany,
    managers:        Field::HasMany,
    id:              Field::Number,
    name:            Field::String,
    created_at:      Field::DateTime,
    updated_at:      Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    name
    employees
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    employees
    managers
    name
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(resource)
    resource.name
  end

  def self.resource_name(_opts)
    'Подразделения'
  end
end
