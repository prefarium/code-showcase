# frozen_string_literal: true

class TelegramAccount < ApplicationRecord
  belongs_to :user

  before_validation :normalize_username

  validates :username, uniqueness: true, presence: true, telegram_username: true
  validates :chat_id, uniqueness: true, allow_nil: true

  private

  def normalize_username
    # Юзер может прислать имя с собакой в начале - нам такое не подходит, дропаем собаку
    self.username = username[1..] if username&.to_s&.first == '@' # rubocop:disable Performance/ArraySemiInfiniteRangeSlice
  end
end
