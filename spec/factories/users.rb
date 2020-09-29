FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    is_active {true}
    is_admin {false}
  end
  factory :admin , class: User do
      email { Faker::Internet.email }
      name { Faker::Name.name }
      is_active {true}
      is_admin {true}
  end
end
