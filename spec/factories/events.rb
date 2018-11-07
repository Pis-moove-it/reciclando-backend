FactoryBot.define do
  factory :event do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    description { Faker::Address.full_addrees }
  end
end
