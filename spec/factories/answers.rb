# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    value { Faker::Lorem.sentence }
    user { association :user }
    question { association :question }
  end
end
