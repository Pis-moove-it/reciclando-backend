FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name.gsub(/[^[:alpha:]]/, '') }
    surname { Faker::Name.first_name.gsub(/[^[:alpha:]]/, '') }
    ci { Faker::Number.number(8) }
    email { Faker::Internet.email }
    organization nil
  end
end
