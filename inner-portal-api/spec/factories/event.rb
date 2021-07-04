# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    start_time { Date.current.beginning_of_day }
    end_time   { Date.current.end_of_day + 1.week }

    author
    participants { create_list(:user, 2, division: author.division) }

    trait(:confirmable) do
      status      { rand(1..3) }
      type        { rand(1..3) }
      confirmable { true }
    end

    trait(:not_confirmable) do
      sequence(:title) { |n| "Событие ##{n}" }
      confirmable { false }
    end

    trait(:without_bindings) do
      author { nil }
      participants { [] }
    end
  end
end
