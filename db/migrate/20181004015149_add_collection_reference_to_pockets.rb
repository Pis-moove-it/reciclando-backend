class AddCollectionReferenceToPockets < ActiveRecord::Migration[5.2]
  def change
    add_reference :pockets, :collection, foreign_key: true
  end
end
