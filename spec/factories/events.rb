# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::Lorem.sentence }
    address { Faker::Address.street_address }

    start_time { Faker::Date.forward.to_s }
    end_time { Faker::Date.forward.to_s }
    cost { Faker::Number.number(5) }

    transient do
      invitations_count { rand(1..5) }
    end

    after(:build) do |event, evaluator|
      event.invitations << build_list(:invitation, evaluator.invitations_count, event: event)
    end
    # factory :event_with_invitations do
    #   invitation do
    #     Array.new(rand(1..5)) { association(:invitation,event: event) }
    #   end
    # end
  end
end
