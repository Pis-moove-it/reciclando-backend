class AddOrganizationRefToCollectionPoints < ActiveRecord::Migration[5.2]
  def change
    add_reference :collection_points, :organization, foreign_key: true
  end
end
