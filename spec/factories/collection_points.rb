FactoryBot.define do
  factory :collection_point do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
