class RemoveKgRecycledPaperFromCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    remove_column :collection_points, :kg_recycled_paper, :float
  end
end
