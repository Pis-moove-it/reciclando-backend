class CollectionPoint < ApplicationRecord
  validates :latitude, :longitude, :type, presence: true
  validates :kg_recycled_glass, :kg_recycled_plastic, :kg_trash, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :organization
  has_many :collections, dependent: :nullify
end
