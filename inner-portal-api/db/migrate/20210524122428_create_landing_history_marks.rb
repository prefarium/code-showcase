# frozen_string_literal: true

class CreateLandingHistoryMarks < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_history_marks do |t|
      t.integer :year, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
