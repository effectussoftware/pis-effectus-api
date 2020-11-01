# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    user { association :user }
    event { association :event }
    attend { Faker::Boolean.boolean }
    confirmation { Faker::Boolean.boolean }
  end
end
