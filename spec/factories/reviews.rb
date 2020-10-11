# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    reviewer { nil }
    user { nil }
    output { 'MyText' }
  end
end
