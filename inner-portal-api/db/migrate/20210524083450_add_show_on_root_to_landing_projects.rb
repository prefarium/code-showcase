# frozen_string_literal: true

class AddShowOnRootToLandingProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :landing_projects, :show_on_root, :boolean, null: false, default: false
  end
end
