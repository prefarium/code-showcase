# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[author assignee pinner] do
    sequence(:email) { |n| "test-#{n}@example.com" }

    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.middle_name }
    middle_name { [nil, Faker::Name.last_name].sample }
    birth_date  { Faker::Date.birthday }
    password    { 'password' }
    phone       { Faker::Number.unique.number(digits: 10).to_s }

    division
    paper_division { division }
    position
  end
end
