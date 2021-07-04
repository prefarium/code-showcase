# frozen_string_literal: true

require 'administrate/base_dashboard'

class ControlDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    division:   Field::BelongsTo,
    manager:    Field::BelongsTo,
    id:         Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    division
    manager
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    division
    manager
  ].freeze

  FORM_ATTRIBUTES = %i[
    division
    manager
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(_control)
    'Управление'
  end

  def self.resource_name(_opts)
    'Руководители подразделений'
  end
end
