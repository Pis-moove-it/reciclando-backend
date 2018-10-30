class AddKgRecycledPlasticToPockets < ActiveRecord::Migration[5.2]
  def change
    add_column :pockets, :kg_recycled_plastic, :float
  end
end
