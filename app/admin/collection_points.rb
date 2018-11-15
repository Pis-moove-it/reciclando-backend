ActiveAdmin.register CollectionPoint do
  menu priority: 7

  permit_params :latitude, :longitude, :status, :active, :kg_recycled_glass, :kg_trash, :kg_recycled_plastic
  actions :index, :show, :edit, :update

  index do
    id_column
    column :latitude
    column :longitude
    column :status
    column :active
    column :kg_recycled_glass
    column :kg_recycled_plastic
    column :kg_trash
    actions
  end

  filter :latitude
  filter :longitude
  filter :kg_trash
  filter :kg_recycled_plastic
  filter :kg_recycled_glass
end
