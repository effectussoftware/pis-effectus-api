# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::Lorem.sentence }
    address { Faker::Address.street_address }
    date { Faker::Date.forward.to_s }
    start_time { '20:00:00' }
    cost { Faker::Number.number(5) }
    duration { '01:30:00' }
  end
end
