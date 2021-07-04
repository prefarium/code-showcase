# frozen_string_literal: true

class CreateNotificationSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :notification_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :email, null: false, default: true
      t.boolean :browser, null: false, default: true

      t.timestamps
    end

    User.find_each { |user| NotificationSetting.create!(user: user, email: false) unless user.notification_setting }
  end
end
