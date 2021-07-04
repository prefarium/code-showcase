# frozen_string_literal: true

class EventPolicy < BasePolicy
  # Если checked_user может создавать события для юзера, то тогда он может и получить доступ к его календарю
  # (при этом по идее прямо все события посмотреть не получится,
  #   Events::FilteredCollectionQuery должен отфильтровать недоступные)
  def access?(user)
    checked_user.possible_assignees.ids.include?(user.id)
  end

  # 1. Естественно, можно смотреть общие события
  # 2. НЕ общее событие можно посмотреть, если есть права на создание событий для всех его участников
  def read?(event)
    return true if event.common?

    participant_ids = event.participant_ids
    (checked_user.possible_assignees.ids & participant_ids).sort == participant_ids.sort
  end

  # Все user_ids должны присутствовать в .possible_assignees
  def assign_users?(user_ids)
    (checked_user.possible_assignees.ids & user_ids).sort == user_ids.sort
  end

  def assign_division?
    checked_user.director? || checked_user.head?
  end

  def change_status?(event)
    checked_user.boss_of?(event.author)
  end

  # 1. Только автор может удалять события
  # 2. Если событие требовало подтверждения и начальник уже отреагировал, то удалять нельзя
  def delete?(event)
    return false if checked_user.id != event.author_id
    return event.pending? if event.confirmable?

    true
  end

  # Уже согласованные события нельзя редактировать
  def edit?(event)
    checked_user.id == event.author_id && (event.pending? || event.status.nil?)
  end
end
