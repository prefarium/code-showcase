# frozen_string_literal: true

require 'administrate/base_dashboard'

module Landing
  class ProjectGroupDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      projects:      Field::HasMany,
      group_binds:   Field::HasMany,
      competences:   Field::HasMany,
      id:            Field::Number,
      title:         Field::String,
      subtitle:      Field::String,
      text_on_cover: Field::Text,
      cover:         Field::ActiveStorage,
      created_at:    Field::DateTime,
      updated_at:    Field::DateTime,
      order_number:  Field::Number
    }.freeze

    COLLECTION_ATTRIBUTES = %i[
      title
      order_number
    ].freeze

    SHOW_PAGE_ATTRIBUTES = %i[
      cover
      title
      subtitle
      text_on_cover
      projects
      order_number
    ].freeze

    FORM_ATTRIBUTES = %i[
      cover
      title
      subtitle
      text_on_cover
      projects
      order_number
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(project_group)
      project_group.title
    end

    def self.resource_name(_opts)
      'Группы проектов'
    end
  end
end
