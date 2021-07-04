# frozen_string_literal: true

class CreateLandingCompetences < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_competences do |t|
      t.string :title, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
