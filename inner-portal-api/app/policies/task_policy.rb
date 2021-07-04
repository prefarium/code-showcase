# frozen_string_literal: true

class TaskPolicy < BasePolicy
  # Если checked_user может назначать задачи юзеру, то тогда он может и получить доступ к его блоку с задачами
  # (при этом по идее прямо все задачи из блока посмотреть не получится,
  #   Tasks::FilteredCollectionQuery должен отфильтровать недоступные)
  def access?(user)
    checked_user.possible_assignees.ids.include?(user.id)
  end

  def read?(task)
    checked_user.id == task.author_id || checked_user.id == task.assignee_id
  end

  def assign?(assignee)
    checked_user.possible_assignees.ids.include?(assignee.id)
  end

  def change_status?(task)
    checked_user.id == task.assignee_id
  end

  def delete?(task)
    checked_user.id == task.author_id
  end

  def edit?(task)
    checked_user.id == task.author_id
  end
end
