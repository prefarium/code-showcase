# frozen_string_literal: true

class CreateLandingMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.string :position, null: false
      t.text :quote, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
