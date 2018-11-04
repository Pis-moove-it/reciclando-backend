FactoryBot.define do
  factory :route do
    length nil
    user nil
  end

  factory :ended_route, parent: :route do
    length { Faker::Number.number(2) }
  end
end
