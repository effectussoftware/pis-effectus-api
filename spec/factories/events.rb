# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::Lorem.sentence }
    address { Faker::Address.street_address }

    start_time { Faker::Date.forward.to_s }
    end_time { Faker::Date.forward.to_s }
    cost { Faker::Number.number(5) }
    factory :invitations do
      invitation do
        Array.new(rand(0..5)) { association(:invitation, event: :event) }
      end
    end
  end
end
