# frozen_string_literal: true

class MakeNotificationsPolymorphic < ActiveRecord::Migration[6.1]
  def up
    change_table :notifications, bulk: true do |t|
      t.remove :type, :type_id
      t.references :notifiable, polymorphic: true
    end
  end

  def down
    change_table :notifications, bulk: true do |t|
      t.integer :type, null: false
      t.integer :type_id, null: false
      t.remove :notifiable_type, :notifiable_id
    end
  end
end
