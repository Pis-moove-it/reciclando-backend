class Organization < ApplicationRecord
  has_secure_password

  has_many :users, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :pockets, dependent: :destroy
  has_many :bales, dependent: :destroy
  has_many :collection_points, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
