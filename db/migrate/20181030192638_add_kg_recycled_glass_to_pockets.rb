class AddKgRecycledGlassToPockets < ActiveRecord::Migration[5.2]
  def change
    add_column :pockets, :kg_recycled_glass, :float
  end
end
