class AddKgRecycledPlasticToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :kg_recycled_plastic, :int
  end
end
