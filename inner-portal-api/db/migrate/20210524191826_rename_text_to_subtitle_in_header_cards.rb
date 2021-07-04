# frozen_string_literal: true

class RenameTextToSubtitleInHeaderCards < ActiveRecord::Migration[6.1]
  def change
    rename_column :landing_header_cards, :text, :subtitle
  end
end
