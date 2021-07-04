# frozen_string_literal: true

class AddStatusChangedAtToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :status_changed_at, :timestamp

    Task.with_deleted.not_assigned.find_each { |task| task.update!(status_changed_at: task.updated_at) }
  end
end
