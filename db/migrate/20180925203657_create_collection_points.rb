class CreateCollectionPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_points do |t|
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
