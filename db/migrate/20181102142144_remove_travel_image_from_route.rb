class RemoveTravelImageFromRoute < ActiveRecord::Migration[5.2]
  def change
    remove_column :routes, :travel_image, :string
  end
end
