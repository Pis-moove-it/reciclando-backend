class ContainerSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :status, :description
end
