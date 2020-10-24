# frozen_string_literal: true

FactoryBot.define do
  factory :review_action_item_effectus, class: ReviewActionItem do
    description { Faker::Lorem.word }
    completed { Faker::Boolean.boolean }
    commitment_owner { 'effectus' }
    review { association :review }
  end

  factory :review_action_item_user, class: ReviewActionItem do
    description { Faker::Lorem.word }
    completed { Faker::Boolean.boolean }
    commitment_owner { 'user' }
    review { association :review }
  end
end
