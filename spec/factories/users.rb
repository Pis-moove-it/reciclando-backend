FactoryBot.define do
  factory :user do
    ci { Faker::Number.number(8) }
    name { Faker::Name.name }
    surname { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
