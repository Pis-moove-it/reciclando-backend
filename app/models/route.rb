class Route < ApplicationRecord
  belongs_to :user

  delegate :organization, to: :user

  has_many :collections, dependent: :destroy
end
