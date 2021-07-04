# frozen_string_literal: true

module Users
  module FilteredCollectionQuery
    def self.call(
      division_id: nil,
      filter: 'all',
      sorting_direction: 'asc',
      sorting_field: 'name'
    )

      users = case filter
              when 'all' then User.all
              when 'managers' then User.head.or(User.where(role: :director))
              else raise IncorrectQueryParameter, I18n.t('errors.users.incorrect_filter', filters: 'all, managers')
              end

      users = users.where(division_id: division_id) if division_id.present?

      case sorting_field
      when 'division'
        users.includes(:division).order(Arel.sql("divisions.name #{sorting_direction}"))
      when 'position'
        users.includes(:position).order(Arel.sql("positions.name #{sorting_direction}"))
      when 'name'
        users.order_by_name(sorting_direction)
      when 'email', 'phone'
        users.order(sorting_field => sorting_direction)
      else
        raise IncorrectQueryParameter,
              I18n.t('errors.users.incorrect_sorting_field', fields: 'division, position, name, email, phone')
      end
    end
  end
end
