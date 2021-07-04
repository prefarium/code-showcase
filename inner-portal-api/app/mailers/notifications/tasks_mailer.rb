# frozen_string_literal: true

module Notifications
  class TasksMailer < ApplicationMailer
    def new_assigned(recipient_id, task_id)
      @recipient = User.find(recipient_id)
      @task      = Task.find(task_id)
      mail(to: @recipient.email, subject: 'Новая задача')
    end

    def status_changed(recipient_id, task_id)
      @recipient      = User.find(recipient_id)
      @task           = Task.find(task_id)
      @status_in_text =
        {
          in_progress: 'приступил к работе над задачей',
          paused:      'поставил на паузу задачу',
          completed:   'закончил работу над задачей',
          rejected:    'отклонил задачу'
        }.stringify_keys.freeze

      mail(to: @recipient.email, subject: "Изменён статус задачи «#{@task.title}»")
    end

    def deleted(recipient_id, task_title)
      @recipient  = User.find(recipient_id)
      @task_title = task_title
      mail(to: @recipient.email, subject: 'Задача отменена')
    end
  end
end
