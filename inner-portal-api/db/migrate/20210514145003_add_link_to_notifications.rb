# frozen_string_literal: true

class AddLinkToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :link, :string
  end
end
