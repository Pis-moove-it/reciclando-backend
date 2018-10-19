class Bale < ApplicationRecord
  enum material: %i[Trash Plastic Glass]
  validates :weight, :material, presence: true

  belongs_to :organization
  belongs_to :user

  delegate :organization, to: :user, allow_nil: true

  before_validation(on: :create) do
    self.organization = organization
  end
end
