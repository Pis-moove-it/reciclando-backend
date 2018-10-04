class RemoveCollectionPocketsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :collection_pockets
  end
end
