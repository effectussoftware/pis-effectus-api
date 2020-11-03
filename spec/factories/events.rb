# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::Lorem.sentence }
    address { Faker::Address.street_address }

    start_time { Faker::Date.forward }
    end_time { start_time +  rand(1..5).hour }
    cost { Faker::Number.number(5) }

    transient do
      invitations_count { rand(1..5) }
    end

    after(:build) do |event, evaluator|
      event.invitations << build_list(:invitation, evaluator.invitations_count, event: event)
    end
  end
end
