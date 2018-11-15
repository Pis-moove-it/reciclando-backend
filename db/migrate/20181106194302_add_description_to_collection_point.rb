class AddDescriptionToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :description, :string
  end
end
