# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require_relative 'fixtures/admin_users'
require_relative 'fixtures/organizations'
require_relative 'fixtures/users'
require_relative 'fixtures/containers'

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
