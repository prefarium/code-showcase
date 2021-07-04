# frozen_string_literal: true

class CreateSenderNameRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :sender_name_requests do |t|
      t.string :name, null: false
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
