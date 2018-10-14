class RouteSerializer < ActiveModel::Serializer
  attributes :id, :length, :travel_image, :created_at, :pockets, :number_of_pockets

  belongs_to :user

  attribute :pockets do
    object.collections.map(&:pockets).flatten
  end

  attribute :number_of_pockets do
    object.collections.map(&:pockets).flatten.count
  end
end
