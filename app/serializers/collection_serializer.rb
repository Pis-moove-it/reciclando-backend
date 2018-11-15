class CollectionSerializer < ActiveModel::Serializer
  attributes :id, :collection_point_id, :route_id

  has_many :pockets
end
