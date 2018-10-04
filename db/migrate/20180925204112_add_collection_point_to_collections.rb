class AddCollectionPointToCollections < ActiveRecord::Migration[5.2]
  def change
    add_reference :collections, :collection_point, foreign_key: true
  end
end
