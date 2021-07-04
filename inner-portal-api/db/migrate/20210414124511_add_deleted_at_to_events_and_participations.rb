# frozen_string_literal: true

class AddDeletedAtToEventsAndParticipations < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :deleted_at, :timestamp
    add_index :events, :deleted_at

    add_column :participations, :deleted_at, :timestamp
    add_index :participations, :deleted_at
  end
end
