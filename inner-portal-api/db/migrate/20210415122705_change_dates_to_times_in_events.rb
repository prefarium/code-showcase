# frozen_string_literal: true

class ChangeDatesToTimesInEvents < ActiveRecord::Migration[6.1]
  def up
    change_table :events, bulk: true do |t|
      t.change :start_date, :timestamp
      t.change :end_date, :timestamp
    end

    rename_column :events, :start_date, :start_time
    rename_column :events, :end_date, :end_time

    Event.find_each do |e|
      e.update_columns(start_time: e.start_time.beginning_of_day, # rubocop:disable Rails/SkipsModelValidations
                       end_time:   e.end_time.end_of_day)
    end
  end

  def down
    change_table :events, bulk: true do |t|
      t.change :start_time, :date
      t.change :end_time, :date
    end

    rename_column :events, :start_time, :start_date
    rename_column :events, :end_time, :end_date
  end
end
