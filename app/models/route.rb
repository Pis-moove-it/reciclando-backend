class Route < ApplicationRecord
  belongs_to :user

  delegate :organization, to: :user

  has_many :collections, dependent: :destroy

  validates :length, numericality: { greater_than: 0 }, allow_nil: true

  def ended?
    length.present? && travel_image.present?
  end
end
