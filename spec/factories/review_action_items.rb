# frozen_string_literal: true

FactoryBot.define do
  factory :review_action_item do
    description { Faker::Lorem.sentence }
    completed { Faker::Boolean.boolean }
    commitment_owner { commitment_owner_function }
    review { association :review }
  end

  def commitment_owner_function
    Faker::Boolean.boolean ? 'user' : 'effectus'
  end
end
