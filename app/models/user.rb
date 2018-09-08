class User < ApplicationRecord
  validates :ci, presence: true, uniqueness: true
  belongs_to :organization
end
