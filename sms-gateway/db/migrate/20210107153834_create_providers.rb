# frozen_string_literal: true

class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      t.string :login, null: false
      t.string :password, null: false
      t.string :name, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :providers, :name, unique: true
  end
end
