class AddKgTrashToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :kg_trash, :int
  end
end
