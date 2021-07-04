# frozen_string_literal: true

require 'administrate/base_dashboard'

module Landing
  class HistoryMarkDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      id:         Field::Number,
      year:       Field::Number,
      text:       Field::Text.with_options(truncate: nil),
      created_at: Field::DateTime,
      updated_at: Field::DateTime
    }.freeze

    COLLECTION_ATTRIBUTES = %i[
      year
      text
    ].freeze

    SHOW_PAGE_ATTRIBUTES = %i[
      year
      text
    ].freeze

    FORM_ATTRIBUTES = %i[
      year
      text
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(history_mark)
      history_mark.year
    end

    def self.resource_name(_opts)
      'Исторические отметки'
    end
  end
end
