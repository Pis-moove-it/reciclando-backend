FactoryBot.define do
  factory :collection_point do
    latitude { Faker::Number.decimal(2, 6) }
    longitude { Faker::Number.decimal(2, 6) }
  end
end
