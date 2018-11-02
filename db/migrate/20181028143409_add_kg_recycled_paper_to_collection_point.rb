class AddKgRecycledPaperToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :kg_recycled_paper, :float
  end
end
