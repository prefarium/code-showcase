# frozen_string_literal: true

module Ideas
  module FilteredCollectionQuery
    def self.call(
      user:,
      for_division: true,
      filter: :active,
      sort_direction: :desc,
      sort_field: :end_date
    )

      ideas = for_division ? user.division.ideas.without_pins_by(user) : user.created_ideas
      ideas = ideas.public_send(filter)
      ideas.order(sort_field => sort_direction)
    end
  end
end
