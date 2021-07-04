# frozen_string_literal: true

FactoryBot.define do
  factory :news do
    sequence(:title) { |n| "Новость ##{n}" }

    body { Faker::ChuckNorris.fact }
    date { Time.current }

    author

    trait(:without_bindings) do
      author { nil }
    end
  end
end
