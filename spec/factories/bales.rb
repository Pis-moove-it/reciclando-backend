FactoryBot.define do
  factory :bale do
    weight { Faker::Number.decimal(2, 2).to_f }
    material { %w[Trash Plastic Glass].sample }
  end
end
