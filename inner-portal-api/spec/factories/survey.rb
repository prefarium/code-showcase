# frozen_string_literal: true

FactoryBot.define do
  factory :survey do
    sequence(:name) { |n| "Название #{n}" }
    sequence(:title) { |n| "Заголовок #{n}" }

    body { Faker::ChuckNorris.fact }
    link { Faker::Internet.url }
  end
end
