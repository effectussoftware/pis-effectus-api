# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { 'MyString' }
    address { 'MyString' }
    date { '2020-10-06 17:36:52' }
    start_time { '2020-10-06 17:36:52' }
    cost { 1 }
    duration { '2020-10-06 17:36:52' }
  end
end
