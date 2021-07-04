# frozen_string_literal: true

class CreateTelegramAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :telegram_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username, null: false, index: { unique: true }
      t.string :chat_id, index: { unique: true }

      t.timestamps
    end
  end
end
