class PocketSerializer < ActiveModel::Serializer
  attributes :id, :serial_number, :state, :weight

  attribute :check_in do
    object.check_in.to_s
  end
end
