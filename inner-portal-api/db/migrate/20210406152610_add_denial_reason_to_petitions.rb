# frozen_string_literal: true

class AddDenialReasonToPetitions < ActiveRecord::Migration[6.1]
  def change
    add_column :petitions, :denial_reason, :text
  end
end
