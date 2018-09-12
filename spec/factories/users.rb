FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    surname { Faker::Name.name }
    ci { Faker::Number.number(8) }
    email { Faker::Internet.email }
    organization nil
  end
end
