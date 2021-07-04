# frozen_string_literal: true

class CreateKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :keys do |t|
      t.string :token, null: false

      t.references :user, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end

    add_index :keys, :token
  end
end
