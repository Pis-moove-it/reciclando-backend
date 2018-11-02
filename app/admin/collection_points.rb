ActiveAdmin.register CollectionPoint do
  permit_params :latitude, :longitude, :status, :active, :kg_recycled_glass, :kg_trash, :kg_recycled_plastic

  index do
    id_column
    column :latitude
    column :longitude
    column :status
    column :active
    column :kg_recycled_glass
    column :kg_recycled_plastic
    column :kg_trash
  end

  filter :latitude
  filter :longitude
  filter :kg_trash
  filter :kg_recycled_plastic
  filter :kg_recycled_glass
end
