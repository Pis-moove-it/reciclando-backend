class AddActiveToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :active, :boolean
  end
end
