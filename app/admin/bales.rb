ActiveAdmin.register Bale do
  permit_params :weight, :material

  filter :weight
  filter :material, as: :select, collection: Bale.materials
  filter :user

  index do
    id_column
    column :weight
    column :material
    column :user
  end

  show title: :id do
    attributes_table do
      rows :id, :weight, :material, :user
    end
  end
end
