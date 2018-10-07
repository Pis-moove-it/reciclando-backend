class PocketSerializer < ActiveModel::Serializer
  attributes :id, :serial_number, :state, :weight
end
