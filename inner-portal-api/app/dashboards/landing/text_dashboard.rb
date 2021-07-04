# frozen_string_literal: true

require 'administrate/base_dashboard'

module Landing
  class TextDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      id:           Field::Number,
      text:         CKEditorField,
      created_at:   Field::DateTime,
      updated_at:   Field::DateTime,
      section_name: Field::Select.with_options(
        searchable: false,
        collection: Landing::Text.section_names.keys.map do |key|
          [Landing::Text.human_attribute_name("section_name.#{key}"), key]
        end
      )
    }.freeze

    COLLECTION_ATTRIBUTES = %i[
      section_name
      text
    ].freeze

    SHOW_PAGE_ATTRIBUTES = %i[
      section_name
      text
    ].freeze

    FORM_ATTRIBUTES = %i[
      section_name
      text
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(text)
      Landing::Text.human_attribute_name("section_name.#{text.section_name}")
    end

    def self.resource_name(_opts)
      'Тексты для различных разделов'
    end
  end
end
