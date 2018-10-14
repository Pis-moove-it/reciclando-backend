class RouteSerializer < ActiveModel::Serializer
  attributes :id, :length, :travel_image, :created_at

  belongs_to :user
end
