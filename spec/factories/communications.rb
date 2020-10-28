# frozen_string_literal: true

FactoryBot.define do
  factory :communication do
    title { Faker::Lorem.word }
    text { Faker::Lorem.sentence }
    published { Faker::Boolean.boolean }
    recurrent_on { nil }
  end

  factory :communication_recurrent, class: Communication do
    title { Faker::Lorem.word }
    text { Faker::Lorem.sentence }
    published { Faker::Boolean.boolean }
    recurrent_on { Faker::Date.backward }
  end

  factory :communication_recurrent_dummy, class: Communication do
    title { Faker::Lorem.word }
    text { Faker::Lorem.sentence }
    published { true }
    updated_at { Faker::Date.backward }
    recurrent_on { nil }
    dummy { true }
  end
end
