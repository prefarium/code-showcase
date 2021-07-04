# frozen_string_literal: true

class CreateLandingBinds < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_binds do |t|
      t.references :landing_competence, null: false, foreign_key: true
      t.references :landing_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
