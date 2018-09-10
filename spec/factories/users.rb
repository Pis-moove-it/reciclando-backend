FactoryBot.define do
  factory :user do
    name 'nombre'
    #name { Faker::Name.name }
    surname 'apellido'
    #surname { Faker::Name.name }
    ci '123456789'
    #ci { Faker::Number.number(8) }
    email 'mail@correo.com'
    #email { Faker::Faker::Internet.email }
    organization nil
  end
end
