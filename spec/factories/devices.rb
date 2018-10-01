FactoryBot.define do
  factory :device do
    device_id '33fa' # { Faker::Device.serial }
    device_type 'smartphone' # { Faker::Device.platform }
    organization_id nil
    user_id nil
  end
end
