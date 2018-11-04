FactoryBot.define do
  factory :route do
    length nil
    #travel_image nil
    user nil
  end

  factory :ended_route, parent: :route do
    length { Faker::Number.number(2) }
    #travel_image { Faker::Internet.url }
  end
end
