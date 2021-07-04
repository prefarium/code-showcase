# frozen_string_literal: true

class AddExtIdToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :ext_id, :string
  end
end
