class Location < ApplicationRecord
  validates :latitude, :longitude, presence: true
  belongs_to :route
end
