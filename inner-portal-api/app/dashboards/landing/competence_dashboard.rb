# frozen_string_literal: true

require 'administrate/base_dashboard'

module Landing
  class CompetenceDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      icon:       Field::ActiveStorage,
      image:      Field::ActiveStorage,
      id:         Field::Number,
      title:      Field::String,
      text:       CKEditorField,
      created_at: Field::DateTime,
      updated_at: Field::DateTime
    }.freeze

    COLLECTION_ATTRIBUTES = %i[
      icon
      title
    ].freeze

    SHOW_PAGE_ATTRIBUTES = %i[
      icon
      image
      title
      text
    ].freeze

    FORM_ATTRIBUTES = %i[
      icon
      image
      title
      text
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(competence)
      competence.title
    end

    def self.resource_name(_opts)
      'Компетенции'
    end
  end
end
