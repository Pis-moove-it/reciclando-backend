class EventSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :description, :collection

  def collection
    byebug
    CollectionSerializer.new(Collection.where(collection_point_id: object.id).first)
  end
end
