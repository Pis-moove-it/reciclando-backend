# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require_relative 'fixtures/admin_users'
require_relative 'fixtures/organizations'
require_relative 'fixtures/users'
require_relative 'fixtures/containers'
require_relative 'fixtures/bales'
require_relative 'fixtures/pockets'
require_relative 'fixtures/routes'
require_relative 'fixtures/collections'
require_relative 'fixtures/questions'
require_relative 'fixtures/locations'

unless AdminUser.count.positive?
  Fixtures::ADMIN_USERS.each do |admin|
    AdminUser.create!(admin)
  end
end

unless Organization.count.positive?
  Fixtures::ORGANIZATIONS.each do |organization|
    Organization.create!(organization)
  end
end

unless User.count.positive?
  Fixtures::USERS.each do |user|
    User.create!(user)
  end
end

unless Container.count.positive?
  Fixtures::CONTAINERS.each do |container|
    Container.create!(container)
  end
end

unless Bale.count.positive?
  Fixtures::BALES.each do |bale|
    Bale.create!(bale)
  end
end

unless Route.count.positive?
  Fixtures::ROUTES.each do |route|
    Route.create!(route)
  end
end

unless Collection.count.positive?
  Fixtures::COLLECTIONS.each do |col|
    Collection.create!(col)
  end
end

unless Pocket.count.positive?
  Fixtures::POCKETS.each do |pocket|
    Pocket.create!(pocket)
  end
end

unless Question.count.positive?
  Fixtures::QUESTIONS.each do |question|
    Question.create!(question)
  end
end

unless Location.count.positive?
  Fixtures::LOCATIONS.each do |location|
    Location.create!(location)
  end
end
