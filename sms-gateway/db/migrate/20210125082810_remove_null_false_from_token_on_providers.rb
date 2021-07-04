# frozen_string_literal: true

class RemoveNullFalseFromTokenOnProviders < ActiveRecord::Migration[6.1]
  def change
    change_column_null :providers, :token, true
  end
end
