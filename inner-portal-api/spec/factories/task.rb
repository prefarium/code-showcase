# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Задача ##{n}" }

    deadline { 1.week.from_now }
    description { Faker::ChuckNorris.fact }

    author
    assignee { author }

    trait(:without_bindings) do
      author { nil }
      assignee { nil }
    end
  end
end
