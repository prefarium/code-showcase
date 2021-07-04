# frozen_string_literal: true

module Digests
  module DailyMorning
    include Base

    def build_daily_morning
      build_tasks
      build_events
      build_ideas
      build_birthdays
    end

    private

    def build_tasks
      # Если вчера исполнитель изменил статус задачи — сообщаем статус
      #   // для автора, если исполнитель - другой человек
      @tasks[:with_changed_status] = Task.where(author_id: @user.id, updated_at: yesterday)
                                         .and(Task.where.not(assignee_id: @user.id))
                                         .not_assigned # имеют не дефолтный статус
                                         .ids

      # Задачи с дедлайном на сегодня (те, у которых статус не “выполнена” и не “отклонена”)
      #   // для автора и исполнителя
      tasks                      = Task.where(deadline: today).not_completed.not_rejected
      @tasks[:deadline_is_today] = tasks.where(assignee_id: @user.id)
                                        .or(tasks.where(author_id: @user.id))
                                        .ids

      # Новые задачи с любым дедлайном, назначенные за вчера (те, у которых статус не “выполнена” и не “отклонена”)
      #   // для исполнителя, если автор - другой человек
      @tasks[:new] = Task.where(assignee_id: @user.id, created_at: yesterday)
                         .and(Task.where.not(author_id: @user.id))
                         .not_completed
                         .not_rejected
                         .ids

      # Назначенная задача отменена вчера
      #   // для исполнителя, если автор - другой человек
      @tasks[:deleted] = Task.only_deleted
                             .where(assignee_id: @user.id, deleted_at: yesterday)
                             .and(Task.where.not(author_id: @user.id))
                             .ids

      @tasks.delete_if { |_k, v| v.blank? }
    end

    def build_events
      # События, где юзер может быть как автором, так и участником
      events = Event.with_participants(@user.id).or(Event.where(author_id: @user.id))

      # Событие начинается сегодня
      #   // длится больше 1 дня
      #   // для автора и участников
      @events[:starting] = events.where('start_date = :today AND end_date > :today', today: today).ids

      # Событие заканчивается сегодня
      #   // длилось больше 1 дня
      #   // для автора и участников
      @events[:ending] = events.where('start_date < :today AND end_date = :today', today: today).ids

      # Событие состоится сегодня
      #   // началось сегодня и сегодня же закончится
      #   // для автора и участников
      @events[:one_day_long] = events.where('start_date = :today AND end_date = :today', today: today).ids

      # Изменения статуса события
      #   // статус изменен вчера
      #   // отклонено/согласовано
      #   // для автора
      @events[:not_pending_anymore] =
        Event.where(author: @user.id, confirmable: true, updated_at: yesterday).not_pending.ids

      # Новое событие назначено
      #   // начинается не сегодня
      #   // назначено вчера
      #   // для участников
      @events[:new_in_future] =
        Event.where(author: @user.id, confirmable: true, created_at: yesterday).ids

      # Назначенное событие отменено
      #   // отменено вчера
      #   // для участников
      @events[:deleted] = Event.only_deleted
                               .with_participants(@user.id)
                               .where(deleted_at: yesterday)
                               .ids

      if @user.boss?
        # Всё события, которые происходят в подчинённых подразделениях
        event_ids = @user.controlled_divisions.reduce([]) { |ids, division| ids << division.events.ids }

        # Новое событие на согласование
        #   // создано вчера
        #   // ещё не имеет реакции руководителя
        #   // начнется не сегодня
        #   // для руководителя
        # (если событие начинается сегодня, то нужно было отправлять письмо
        #   с уведомлением о необходимости согласования сразу после создания такого события)
        # TODO: сделать письмо
        @events[:new_pending] = Event.pending
                                     .where(id:          event_ids,
                                            confirmable: true,
                                            created_at:  yesterday)
                                     .and(Event.where.not(start_date: today))
                                     .ids

        # Старое событие на согласование
        #   // создано когда-то
        #   // ещё не имеет реакции руководителя
        #   // начинается завтра
        #   // для руководителя
        @events[:pending_and_starting_tomorrow] =
          Event.pending.where(id: event_ids, confirmable: true, start_date: tomorrow).ids

        # Событие начинается сегодня
        #   // согласовано руководителем
        #   // для руководителя
        @events[:approved_and_starting_today] =
          Event.approved.where(id: event_ids, confirmable: true, start_date: today).ids
      end

      @events.delete_if { |_k, v| v.blank? }
    end

    def build_ideas
      # Результаты голосования по идеям, завершившимся вчера
      #   // для автора и коллег
      @ideas[:ended] = Idea.ended.where(division_id: @user.division_id, updated_at: yesterday).ids

      # Новые идеи, предложенные вчера
      #   // для автора и коллег
      @ideas[:new] = Idea.active.where(division_id: @user.division_id, created_at: yesterday).ids

      # Идеи, голосование по которым закончится сегодня и у пользователя есть последняя возможность проголосовать
      #   // для автора и коллег
      #   (если уже голосовал - не отправляем)
      voted_ideas_ids              = @user.find_voted_items.map(&:id)
      @ideas[:last_chance_to_vote] = Idea.active
                                         .where(division_id: @user.division_id, end_date: today)
                                         .and(Idea.where.not(id: voted_ideas_ids))
                                         .ids

      @ideas.delete_if { |_k, v| v.blank? }
    end

    def build_birthdays
      # TODO: сделать
    end
  end
end
