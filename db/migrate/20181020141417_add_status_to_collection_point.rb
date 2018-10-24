class AddStatusToCollectionPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_points, :status, :integer
  end
end
