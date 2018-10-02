class AddDefaultToPocketsState < ActiveRecord::Migration[5.2]
  def change
    change_column :pockets, :state, :integer, default: 0
  end
end
