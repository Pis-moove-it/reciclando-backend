FactoryBot.define do
  factory :container do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    status { Faker::Number.between(0, 2) }
    active { Faker::Boolean.boolean }
  end
end
