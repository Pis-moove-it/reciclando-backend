module Fixtures
  POCKETS = [
    {
      serial_number: '123451',
      weight: nil,
      organization_id: 1,
      collection_id: 1
    },
    {
      serial_number: '123452',
      weight: nil,
      organization_id: 1,
      collection_id: 1
    },
    {
      serial_number: '123453',
      weight: nil,
      organization_id: 1,
      collection_id: 1
    },
    {
      serial_number: '123454',
      weight: nil,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current
    },
    {
      serial_number: '123455',
      weight: nil,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current + 10
    },
    {
      serial_number: '123456',
      weight: nil,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current + 20
    }
  ].freeze
end
