FactoryBot.define do
  factory :device do
    device_id { Faker::Device.serial }
    device_type { Faker::Device.platform }
    organization_id nil
    user_id nil
  end
end
