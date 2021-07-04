# frozen_string_literal: true

class RemoveAdminFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :admin, :boolean, default: false
  end
end
