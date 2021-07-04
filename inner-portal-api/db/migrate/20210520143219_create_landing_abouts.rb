# frozen_string_literal: true

class CreateLandingAbouts < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_abouts do |t|
      t.text :text, null: false

      t.timestamps
    end
  end
end
