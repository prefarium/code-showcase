# frozen_string_literal: true

class AddProviderToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :operator, :integer, default: 0, null: false
  end
end
