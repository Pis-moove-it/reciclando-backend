class AddKgTrashToPockets < ActiveRecord::Migration[5.2]
  def change
    add_column :pockets, :kg_trash, :float
  end
end
