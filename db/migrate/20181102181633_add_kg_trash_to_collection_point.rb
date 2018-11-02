class AddKgTrashToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :kg_trash, :float, default: '0.0'
  end
end
