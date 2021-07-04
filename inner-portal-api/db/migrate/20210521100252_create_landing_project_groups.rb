# frozen_string_literal: true

class CreateLandingProjectGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_project_groups do |t|
      t.string :title, null: false
      t.string :subtitle, null: false
      t.text :title_text, null: false

      t.timestamps
    end
  end
end
