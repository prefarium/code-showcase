# frozen_string_literal: true

FactoryBot.define do
  factory :position do
    sequence(:name) { |n| "Должность ##{n}" }
  end
end
