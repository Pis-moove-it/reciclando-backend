class RouteSerializer < ActiveModel::Serializer
  attributes :id, :length

  attribute :created_at do
    object.created_at.to_s
  end

  belongs_to :user

  has_many :pockets, each_serializer: PocketSerializer do
    object.collections.map(&:pockets).flatten
  end

  has_many :locations, each_serializer: LocationSerializer do
    object.collections.map(&:locations).flatten
  end
end
