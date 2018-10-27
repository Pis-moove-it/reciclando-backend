class Route < ApplicationRecord
  before_update :check_in_pockets

  belongs_to :user

  delegate :organization, to: :user

  has_many :collections, dependent: :destroy

  validates :length, numericality: { greater_than: 0 }, allow_nil: true

  def ended?
    length.present? && travel_image.present?
  end

  private

  def check_in_pockets
    collections.map(&:check_in_pockets)
  end
end
