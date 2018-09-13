class Bale < ApplicationRecord
  enum material: %i[Trash Plastic Glass]
  validates :weight, :material, presence: true
end
