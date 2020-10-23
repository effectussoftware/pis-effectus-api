# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { Faker::Name.name }
    description { Faker::Lorem.word }
    reviewer { association :user }
    user { association :user }
  end
end
