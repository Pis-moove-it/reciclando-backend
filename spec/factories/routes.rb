FactoryBot.define do
  factory :route do
    length { Faker::Number.number(2) }
    user nil
  end
end
