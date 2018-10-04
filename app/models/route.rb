class Route < ApplicationRecord
  belongs_to :user

  has_many :collections, dependent: :destroy
end
