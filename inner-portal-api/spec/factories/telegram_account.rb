# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_account do
    sequence(:username) { |n| "username-#{n}" }
    sequence(:chat_id, &:to_s)

    user
  end
end
