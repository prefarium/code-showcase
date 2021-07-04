# frozen_string_literal: true

module PaginationHelper
  def paginable!(page: 1, entities_on_page: ENV.fetch('ENTITIES_ON_PAGE', 10))
    parameter name:        :page,
              in:          :query,
              type:        :integer,
              required:    false,
              default:     page,
              description: 'Номер страницы'

    parameter name:        :entities_on_page,
              in:          :query,
              type:        :integer,
              required:    false,
              default:     entities_on_page,
              description: 'Количество записей на 1 странице'
  end
end
