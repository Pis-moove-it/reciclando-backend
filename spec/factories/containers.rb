FactoryBot.define do
  factory :container do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    status { Faker::Number.between(0, 2) }
    active { Faker::Boolean.boolean }
  end

  factory :available_container, parent: :container do
    status { %w[Ok Damaged].sample }
    active true
  end
  factory :ok_container, parent: :container do
    status { 'Ok' }
    active true
  end

  factory :damaged_container, parent: :container do
    status { 'Damaged' }
    active true
  end

  factory :removed_container, parent: :container do
    status { 'Removed' }
    active true
  end

  factory :inactive_container, parent: :container do
    status { %i[Ok Damaged].sample }
    active false
  end
end
