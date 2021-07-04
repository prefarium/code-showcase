# frozen_string_literal: true

FactoryBot.define do
  factory :idea do
    sequence(:title) { |n| "Идея №#{n}" }

    description { Faker::ChuckNorris.fact }
    end_date    { 1.week.from_now }

    author
    division { author.division }

    trait(:without_bindings) do
      author   { nil }
      division { nil }
    end
  end
end
