class User < ApplicationRecord
  validates :ci, uniqueness: true, format: { with: /\A[0-9]{5,8}\z/ }
  validates :name, :surname, :email, :ci, presence: true
  validates :name, :surname, format: { with: /[[:alpha:]]/ }
  validates :email, format: { with: /.+@.+\..+/ }
  belongs_to :organization
end
