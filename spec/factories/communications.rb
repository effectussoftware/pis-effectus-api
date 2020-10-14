# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :communication do
    title { Faker::Lorem.word }
    text { Faker::Lorem.sentence }
    published { Faker::Boolean.boolean }
  end
end
