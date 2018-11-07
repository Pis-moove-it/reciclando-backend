class EventSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :description

  has_many :collections
end
