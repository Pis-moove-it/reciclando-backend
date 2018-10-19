class Bale < ApplicationRecord
  enum material: %i[Trash Plastic Glass]
  validates :weight, :material, presence: true

  belongs_to :organization
  belongs_to :user

  self.per_page = 5
end
