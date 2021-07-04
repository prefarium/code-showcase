# frozen_string_literal: true

class AddTypeInRussianToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :type_in_russian, :string
  end
end
