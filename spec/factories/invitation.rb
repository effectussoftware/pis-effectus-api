# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    user { nil }
    event { nil }
    attend { false }
    confirmation { false }
  end
end
