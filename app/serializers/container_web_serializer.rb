class ContainerWebSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :status, :kg_trash, :kg_recycled_glass, :kg_recycled_plastic
end
