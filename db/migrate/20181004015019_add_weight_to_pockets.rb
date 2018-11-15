class AddWeightToPockets < ActiveRecord::Migration[5.2]
  def change
    add_column :pockets, :weight, :float
  end
end
