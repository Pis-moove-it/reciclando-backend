class CollectionPoint < ApplicationRecord
  validates :latitude, :longitude, :type, presence: true

  belongs_to :organization
  has_many :collections, dependent: :nullify
end
