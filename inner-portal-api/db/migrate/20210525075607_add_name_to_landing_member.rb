# frozen_string_literal: true

class AddNameToLandingMember < ActiveRecord::Migration[6.1]
  def up
    Landing::Member.destroy_all

    change_table :landing_members, bulk: true do |t|
      t.string :name, null: false
      t.remove :first_name, :last_name, :middle_name
    end
  end

  def down
    change_table :landing_members, bulk: true do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.remove :name
    end
  end
end
