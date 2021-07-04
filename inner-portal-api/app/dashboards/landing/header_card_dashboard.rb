# frozen_string_literal: true

require 'administrate/base_dashboard'

module Landing
  class HeaderCardDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      id:         Field::Number,
      title:      Field::String,
      subtitle:   Field::String.with_options(truncate: nil),
      created_at: Field::DateTime,
      updated_at: Field::DateTime
    }.freeze

    COLLECTION_ATTRIBUTES = %i[
      title
      subtitle
    ].freeze

    SHOW_PAGE_ATTRIBUTES = %i[
      title
      subtitle
    ].freeze

    FORM_ATTRIBUTES = %i[
      title
      subtitle
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(header_card)
      header_card.title
    end

    def self.resource_name(_opts)
      'Карточки для хэдера'
    end
  end
end
