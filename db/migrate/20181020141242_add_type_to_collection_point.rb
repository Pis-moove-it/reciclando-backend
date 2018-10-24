class AddTypeToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :type, :string
  end
end
