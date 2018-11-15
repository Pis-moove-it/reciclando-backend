class AddTravelImageToRoutes < ActiveRecord::Migration[5.2]
  def change
    add_column :routes, :travel_image, :string
  end
end
