# frozen_string_literal: true

module Tasks
  module FilteredCollectionQuery
    # created - те, что юзер создал
    # assigned - те, где юзер исполнитель
    # all - те и те
    FILTERS        = %w[created assigned all].freeze
    SORTING_FIELDS = %w[title deadline status].freeze

    def self.call(
      current_user:,
      user:,
      filter: 'assigned',
      sorting_direction: 'desc',
      sorting_field: 'deadline'
    )

      if FILTERS.exclude?(filter) || SORTING_FIELDS.exclude?(sorting_field)
        raise IncorrectQueryParameter, I18n.t('errors.common.incorrent_query_parameters')
      end

      tasks = user.public_send("#{filter}_tasks")

      # текущий пользователь может увидеть задачу, только если он участвует в ней с той или иной стороны
      tasks = tasks.where(author_id: current_user.id).or(tasks.where(assignee_id: current_user.id))
      tasks.order(sorting_field => sorting_direction, created_at: :desc)
    end
  end
end
