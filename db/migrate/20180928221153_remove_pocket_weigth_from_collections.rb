class RemovePocketWeigthFromCollections < ActiveRecord::Migration[5.2]
  def change
    remove_column :collections, :pocket_weigth, :integer
  end
end
