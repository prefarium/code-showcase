# frozen_string_literal: true

class AddSenderNameToKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :keys, :sender_name, :string
  end
end
