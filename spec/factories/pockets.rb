FactoryBot.define do
  factory :pocket do
    serial_number { Faker::Number.number(10) }
    organization nil
    collection nil
    kg_trash nil
    kg_recycled_plastic nil
    kg_recycled_glass nil
  end

  factory :classified_pocket, parent: :pocket do
    state { 'Classified' }
    weight { Faker::Number.decimal(2, 2).to_f }
    kg_trash { Faker::Number.decimal(2, 2).to_f }
    kg_recycled_plastic { Faker::Number.decimal(2, 2).to_f }
    kg_recycled_glass { Faker::Number.decimal(2, 2).to_f }
  end

  factory :unclassified_pocket, parent: :pocket do
    state { %w[Unweighed Weighed].sample }
  end

  factory :weighed_pocket, parent: :pocket do
    state { 'Weighed' }
    weight { Faker::Number.decimal(2, 2).to_f }
  end

  factory :unweighed_pocket, parent: :pocket do
    state { 'Unweighed' }
    weight nil
  end
end
