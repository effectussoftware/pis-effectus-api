FactoryBot.define do
  factory :review do
    reviewer { nil }
    user { nil }
    output { "MyText" }
  end
end
