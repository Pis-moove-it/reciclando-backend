FactoryBot.define do
  factory :pocket do
    serial_number { Faker::Number.number(10) }
    organization nil
    collection nil
  end

  factory :classified_pocket, parent: :pocket do
    state { 'Classified' }
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
