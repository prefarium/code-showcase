# frozen_string_literal: true

class AddCheckboxesToNews < ActiveRecord::Migration[6.1]
  def change
    change_table :news, bulk: true do |t|
      t.boolean :for_landing, null: false, default: false
      t.boolean :for_portal, null: false, default: false
    end

    News.update(for_portal: true) # rubocop:disable Rails/SaveBang
  end
end
