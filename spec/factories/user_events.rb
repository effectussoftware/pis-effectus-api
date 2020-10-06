# frozen_string_literal: true

FactoryBot.define do
  factory :user_event do
    user { nil }
    event { nil }
    attend { false }
    confirmation { false }
  end
end
