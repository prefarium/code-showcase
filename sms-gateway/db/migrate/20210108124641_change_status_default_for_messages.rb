# frozen_string_literal: true

class ChangeStatusDefaultForMessages < ActiveRecord::Migration[6.1]
  def change
    change_column_default :messages, :status, from: nil, to: 0
  end
end
