# frozen_string_literal: true

module Events
  module CollectionForCalendarQuery
    # created - те, что юзер создал
    # assigned - те, где юзер участник
    # all - те и те
    FILTERS = %w[created assigned all].freeze

    # rubocop:disable Metrics/ParameterLists
    def self.call(
      current_user:,
      user:,
      range_of_days:,
      for_division: false,
      filter: 'all',
      common: true
    )

      raise IncorrectQueryParameter, I18n.t('errors.common.incorrent_query_parameters') if FILTERS.exclude?(filter)

      events = if for_division
                 # Ахтунг! Сейчас событие, созданное на весь отдел, не содержит начальника отдела в участниках,
                 #  потому мы можем отфильтровать события начальника вот таким образом
                 # Если это поменяется - нужно менять алгоритм фильтрации
                 user.division.events.where.not(participations: { participant_id: current_user.boss.id })
               else
                 user.public_send("#{filter}_events")
               end

      events = events.or(Event.common) if common
      events = events.without_private if current_user.id != user.id && !current_user.boss_of?(user)
      events.in_period(range_of_days)
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
