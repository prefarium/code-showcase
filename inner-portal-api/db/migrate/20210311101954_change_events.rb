# frozen_string_literal: true

class ChangeEvents < ActiveRecord::Migration[6.1]
  def up
    change_table :events, bulk: true do |t|
      t.references :division, null: true, foreign_key: true
      t.change_null :author_id, true

      t.change :start_time, :date
      t.change :end_time, :date

      t.rename :start_time, :start_date
      t.rename :end_time, :end_date
    end
  end

  def down
    change_table :events, bulk: true do |t|
      t.rename :start_date, :start_time
      t.rename :end_date, :end_time

      t.change :start_time, :datetime
      t.change :end_time, :datetime

      t.remove_references :division
      t.change_null :author_id, false
    end
  end
end
