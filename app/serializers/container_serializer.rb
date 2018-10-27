class ContainerSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :status_id

  def status_id
    read_attribute_for_serialization(:status)
  end
end
