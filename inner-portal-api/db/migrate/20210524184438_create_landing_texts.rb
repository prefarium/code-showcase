# frozen_string_literal: true

class CreateLandingTexts < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_texts do |t|
      t.integer :section_name, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
