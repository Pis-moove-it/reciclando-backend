FactoryBot.define do
  factory :bale do
    weight { Faker::Number.decimal(2, 2).to_f }
    material 'Glass'
  end
  factory :second_bale do
    weight { Faker::Number.decimal(2, 2).to_f }
    material 'Glass'
  end
end
