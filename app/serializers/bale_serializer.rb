class BaleSerializer < ActiveModel::Serializer
  attributes :id, :weight, :material_id

  def material_id
    return 1 if object.material == 'Trash'
    return 2 if object.material == 'Plastic'
    return 3 if object.material == 'Glass'
  end
end
