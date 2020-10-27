# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { Faker::Lorem.word }
    comments { Faker::Lorem.sentence }
    reviewer { association :user }
    user { association :user }

    factory :review_with_action_items do
      reviewer_action_items do
        Array.new(rand(0..5)) { association(:reviewer_action_item) }
      end

      user_action_items do
        Array.new(rand(0..5)) { association(:user_action_item) }
      end
    end
  end
end
