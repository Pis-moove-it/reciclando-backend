ActiveAdmin.register CollectionPoint do
  permit_params :latitude, :longitude, :status, :active, :kg_recycled_glass, :kg_trash, :kg_recycled_plastic

  filter :latitude
  filter :longitude
  filter :kg_trash
  filter :kg_recycled_plastic
  filter :kg_recycled_glass
end
