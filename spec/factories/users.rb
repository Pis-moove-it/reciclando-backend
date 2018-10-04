FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    surname { Faker::Name.first_name }
    ci { Faker::Number.number(8) }
    email { Faker::Internet.email }
    organization nil
  end
end
