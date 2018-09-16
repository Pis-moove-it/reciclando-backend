FactoryBot.define do
  factory :bale do
    weight { Faker::Number.decimal(2, 2) }
    material { Faker::Number.between(0, 2) }
  end
end
