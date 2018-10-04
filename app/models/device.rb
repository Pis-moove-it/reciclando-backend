class Device < ApplicationRecord
  has_secure_token :auth_token

  belongs_to :organization
  belongs_to :user, optional: true
end
