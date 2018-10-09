class RouteSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :user
end
