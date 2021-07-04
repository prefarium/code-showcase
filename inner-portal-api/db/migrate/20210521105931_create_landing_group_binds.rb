# frozen_string_literal: true

class CreateLandingGroupBinds < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_group_binds do |t|
      t.references :landing_competence, null: false, foreign_key: true
      t.references :landing_project_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
