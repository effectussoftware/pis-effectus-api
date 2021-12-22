# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    survey { association :survey }
    name { Faker::Lorem.sentence }
    type { ["Question::Numeric", "Question::Text"].sample }
    max_range { rand(6..10) }
    min_range { rand(1..5) }
  end
end
