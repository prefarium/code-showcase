# frozen_string_literal: true

class CreateLandingHeaderCards < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_header_cards do |t|
      t.string :number, null: false
      t.string :text, null: false

      t.timestamps
    end
  end
end
