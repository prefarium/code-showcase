# frozen_string_literal: true

class ChangeCostTypeForMessages < ActiveRecord::Migration[6.1]
  def change
    change_column :messages, :cost, :float
  end
end
