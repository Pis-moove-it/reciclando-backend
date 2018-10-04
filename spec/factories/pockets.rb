FactoryBot.define do
  factory :pocket do
    serial_number { Faker::Number.number(10) }
    organization nil
  end

  factory :classified_pocket, parent: :pocket do
    state { 'Classified' }
  end

  factory :unclassified_pocket, parent: :pocket do
    state { %w[Unweighed Weighed].sample }
  end
end
