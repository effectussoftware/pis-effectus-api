# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    reviewer { association :user }
    user { association :user }
  end
end
