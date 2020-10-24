# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { Faker::Lorem.word }
    comments { Faker::Lorem.sentence }
    reviewer { association :user }
    user { association :user }
  end
end
