# frozen_string_literal: true

class RenameSomeColumnsOnLandingTables < ActiveRecord::Migration[6.1]
  def change
    rename_column :landing_projects, :title_text, :text_on_cover
    rename_column :landing_project_groups, :title_text, :text_on_cover
  end
end
