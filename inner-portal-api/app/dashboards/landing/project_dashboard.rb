# frozen_string_literal: true

require 'administrate/base_dashboard'

module Landing
  class ProjectDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      project_group: Field::BelongsTo,
      binds:         Field::HasMany,
      competences:   Field::HasMany,
      id:            Field::Number,
      title:         Field::String,
      subtitle:      Field::String,
      text_on_cover: Field::Text,
      cover:         Field::ActiveStorage,
      text:          CKEditorField,
      created_at:    Field::DateTime,
      updated_at:    Field::DateTime,
      show_on_root:  Field::Boolean,
      order_number:  Field::Number
    }.freeze

    COLLECTION_ATTRIBUTES = %i[
      title
      order_number
      show_on_root
    ].freeze

    SHOW_PAGE_ATTRIBUTES = %i[
      cover
      title
      subtitle
      text_on_cover
      text
      project_group
      show_on_root
      order_number
    ].freeze

    FORM_ATTRIBUTES = %i[
      cover
      title
      subtitle
      text_on_cover
      text
      project_group
      show_on_root
      order_number
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(project)
      project.title
    end

    def self.resource_name(_opts)
      'Проекты'
    end
  end
end
