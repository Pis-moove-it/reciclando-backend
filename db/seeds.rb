# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require_relative 'fixtures/admin_users'

unless AdminUser.count.positive?
  Fixtures::ADMIN_USERS.each do |admin|
    AdminUser.create!(admin)
  end
end
