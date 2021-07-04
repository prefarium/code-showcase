# frozen_string_literal: true

class AddOrderNumberToProjectsAndGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :landing_projects, :order_number, :integer
    add_column :landing_project_groups, :order_number, :integer
  end
end
