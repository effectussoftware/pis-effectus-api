FactoryBot.define do
  factory :review do
    reviewer { association :user }
    user { association :user }
  end
end
