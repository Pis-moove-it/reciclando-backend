FactoryBot.define do
  factory :container do
    status { Faker::Number.between(0, 2) }
    active true
  end
end
