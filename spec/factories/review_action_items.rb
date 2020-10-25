# frozen_string_literal: true

FactoryBot.define do
  factory :reviewer_action_item, class: 'ReviewActionItem' do
    description { Faker::Lorem.sentence }
    completed { Faker::Boolean.boolean }
    reviewer_review_id { association :review }
    user_review_id { nil }            
  end

  factory :user_action_item, class: 'ReviewActionItem' do
    description { Faker::Lorem.sentence }
    completed { Faker::Boolean.boolean }
    reviewer_review_id { nil }
    user_review_id { association :review }            
  end
end
