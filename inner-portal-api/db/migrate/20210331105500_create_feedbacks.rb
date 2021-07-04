# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.text :body, null: false
      t.integer :status, null: false, default: 1
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
