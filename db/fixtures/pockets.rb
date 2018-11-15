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
    },
    {
      serial_number: '123457',
      state: 'Weighed',
      weight: 50,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 3600
    },
    {
      serial_number: '123458',
      state: 'Weighed',
      weight: 55,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 3600
    },
    {
      serial_number: '123459',
      state: 'Weighed',
      weight: 64,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 7200
    },
    {
      serial_number: '123460',
      state: 'Weighed',
      weight: 45,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 10_800
    },
    {
      serial_number: '123461',
      state: 'Weighed',
      weight: 92,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 10_800
    },
    {
      serial_number: '123462',
      state: 'Classified',
      weight: 69,
      kg_recycled_plastic: 5,
      kg_recycled_glass: 1,
      kg_trash: 63,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 10_800
    },
    {
      serial_number: '123463',
      state: 'Classified',
      weight: 72,
      kg_recycled_plastic: 6,
      kg_recycled_glass: 2,
      kg_trash: 64,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 14_400
    },
    {
      serial_number: '123464',
      state: 'Classified',
      weight: 57,
      kg_recycled_plastic: 10,
      kg_recycled_glass: 2,
      kg_trash: 45,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 11_300
    },
    {
      serial_number: '123465',
      state: 'Classified',
      weight: 81,
      kg_recycled_plastic: 8,
      kg_recycled_glass: 3,
      kg_trash: 70,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 12_200
    },
    {
      serial_number: '123466',
      state: 'Classified',
      weight: 52,
      kg_recycled_plastic: 3,
      kg_recycled_glass: 0,
      kg_trash: 49,
      organization_id: 1,
      collection_id: 1,
      check_in: Time.current - 9100
    }
  ].freeze
end
