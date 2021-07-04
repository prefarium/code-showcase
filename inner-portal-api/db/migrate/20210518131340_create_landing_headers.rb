# frozen_string_literal: true

class CreateLandingHeaders < ActiveRecord::Migration[6.1]
  def change
    create_table :landing_headers do |t|
      t.string :title, null: false
      t.string :text, null: false

      t.timestamps
    end
  end
end
