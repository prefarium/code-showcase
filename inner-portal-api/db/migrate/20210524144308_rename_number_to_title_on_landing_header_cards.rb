# frozen_string_literal: true

class RenameNumberToTitleOnLandingHeaderCards < ActiveRecord::Migration[6.1]
  def change
    rename_column :landing_header_cards, :number, :title
  end
end
