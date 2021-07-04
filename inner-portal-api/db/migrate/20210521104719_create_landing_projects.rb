# frozen_string_literal: true

class CreateLandingProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_projects do |t|
      t.string :title, null: false
      t.string :subtitle, null: false
      t.text :title_text, null: false
      t.text :text, null: false
      t.references :landing_project_group, null: true, foreign_key: true

      t.timestamps
    end
  end
end
