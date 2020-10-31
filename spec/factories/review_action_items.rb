# frozen_string_literal: true

FactoryBot.define do
  factory :reviewer_action_item, class: 'ReviewActionItem' do
    description { Faker::Lorem.sentence }
    completed { Faker::Boolean.boolean }
  end

  factory :user_action_item, class: 'ReviewActionItem' do
    description { Faker::Lorem.sentence }
    completed { Faker::Boolean.boolean }
  end
end
