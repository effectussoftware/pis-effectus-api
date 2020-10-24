# frozen_string_literal: true

FactoryBot.define do
  factory :review, class: Review do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    reviewer { association :user }
    user { association :user }
  end
end
