# frozen_string_literal: true

class RemoveDefaultValueAndNullConstraintFromMessagesOperator < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messages, :operator, true
    change_column_default :messages, :operator, from: 0, to: nil
  end
end
