# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    sequence(:name) { |n| "Документ ##{n}" }
  end
end
