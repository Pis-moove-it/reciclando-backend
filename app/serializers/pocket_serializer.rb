class PocketSerializer < ActiveModel::Serializer
  attributes :id, :serial_number, :state, :weight, :kg_trash, :kg_recycled_plastic, :kg_recycled_glass

  attribute :check_in do
    object.check_in.strftime('%H:%M:%S %d/%m/%Y')
  end
end
