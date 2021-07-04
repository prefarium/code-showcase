# frozen_string_literal: true

class RenameActualDivisionIntoDivisionInUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :division_id, :paper_division_id
    rename_column :users, :actual_division_id, :division_id
  end
end
