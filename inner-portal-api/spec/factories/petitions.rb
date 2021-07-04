# frozen_string_literal: true

FactoryBot.define do
  factory :petition do
    sequence(:title) { |n| "Обращение #{n}" }

    body { Faker::ChuckNorris.fact }

    author

    trait(:without_bindings) do
      author { nil }
    end
  end
end
