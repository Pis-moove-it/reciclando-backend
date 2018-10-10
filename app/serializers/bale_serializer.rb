class BaleSerializer < ActiveModel::Serializer
  attributes :id, :weight, :material

  belongs_to :user
end
