class Bale < ApplicationRecord
  enum material: %i[Trash Plastic Glass]

  validates :material, presence: true
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0.001 }

  belongs_to :organization
  belongs_to :user

  delegate :organization, to: :user, allow_nil: true

  before_validation(on: :create) do
    self.organization = organization
  end
end
