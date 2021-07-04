# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.string :body, null: false
      t.boolean :read, null: false, default: false
      t.integer :type, null: false
      t.integer :type_id, null: false

      t.timestamps
    end
  end
end
