# frozen_string_literal: true

class RemoveDivisionIdFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_reference :events, :division
  end
end
