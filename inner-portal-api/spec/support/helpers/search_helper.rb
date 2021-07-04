# frozen_string_literal: true

module SearchHelper
  def searchable!
    parameter name:        :search_query,
              in:          :query,
              type:        :string,
              required:    false,
              description: 'Поисковый запрос'
  end
end
