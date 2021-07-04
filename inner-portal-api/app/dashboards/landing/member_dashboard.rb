# frozen_string_literal: true

require 'administrate/base_dashboard'

module Landing
  class MemberDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      avatar:     Field::ActiveStorage,
      id:         Field::Number,
      name:       Field::String,
      position:   Field::String,
      quote:      Field::Text,
      text:       CKEditorField,
      created_at: Field::DateTime,
      updated_at: Field::DateTime
    }.freeze

    COLLECTION_ATTRIBUTES = %i[
      name
    ].freeze

    SHOW_PAGE_ATTRIBUTES = %i[
      avatar
      name
      position
      quote
      text
    ].freeze

    FORM_ATTRIBUTES = %i[
      avatar
      name
      position
      quote
      text
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(member)
      member.name
    end

    def self.resource_name(_opts)
      'Члены команды'
    end
  end
end
