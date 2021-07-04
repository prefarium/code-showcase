# frozen_string_literal: true

class TaskSerializer < BaseSerializer
  identifier :id

  view :base do
    association :assignee, blueprint: UserSerializer, view: :short_name_with_avatar
    association :author, blueprint: UserSerializer, view: :short_name_with_avatar

    field :deadline, datetime_format: '%d.%m.%Y'
    field :reject_reason
    field :status
    field :title

    field :time_left do |task|
      task.deadline.present? ? time_left_for(task) : 'неограничено'
    end

    # Флаг, который означает отображать статус иконкой или прописывать его словами
    field :status_in_words do |task, options|
      options[:current_user] == task.author && options[:current_user] != task.assignee
    end

    field :status_in_russian do |task|
      Task.human_attribute_name("status.#{task.status}")
    end
  end

  view :index do
    include_view :base
  end

  view :show do
    include_view :base
    field :description

    field :canceled do |task| # rubocop:disable Style/SymbolProc
      task.canceled?
    end
  end

  class << self
    private

    def no_time_left_for(task)
      return task.deadline.strftime('%d.%m.%Y') if task.deadline.year != Date.current.year

      "#{task.deadline.day} #{I18n.t('date.abbr_month_names')[task.deadline.month]}"
    end

    def time_left_for(task)
      time_left = (task.deadline - Date.current).to_i + 1

      case time_left
      when (..0) then no_time_left_for task
      when 1 then 'сегодня'
      else "#{time_left} #{I18n.t('cases.day', count: time_left)}"
      end
    end
  end
end
