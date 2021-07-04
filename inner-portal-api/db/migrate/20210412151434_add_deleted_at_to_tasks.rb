# frozen_string_literal: true

class AddDeletedAtToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deleted_at, :timestamp
    add_index :tasks, :deleted_at
  end
end
