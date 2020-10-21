# frozen_string_literal: true

FactoryBot.define do
  factory :review_action_item do
    description { 'MyText' }
    type { '' }
    user { nil }
    review { nil }
  end
end
