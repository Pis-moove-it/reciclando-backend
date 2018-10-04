class AddPocketWeightToCollectionPockets < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_pockets, :pocket_weigth, :float
  end
end
