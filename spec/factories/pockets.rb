FactoryBot.define do
  factory :pocket do
    serial_number { Faker::Number.number(10) }
    state { %w[Unweighed Weighed Classified].sample }
    organization nil
  end
end
