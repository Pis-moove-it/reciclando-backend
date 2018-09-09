class User < ApplicationRecord
  validates :ci, uniqueness: true
  validates :name, :surname, :email, :ci, presence: true
  belongs_to :organization
end
