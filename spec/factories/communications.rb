# frozen_string_literal: true

FactoryBot.define do
  factory :communication do
    title { 'MyText' }
    text { 'MyText' }
    published { '' }
  end
end
