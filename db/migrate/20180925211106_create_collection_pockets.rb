class CreateCollectionPockets < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_pockets do |t|
      t.references :pocket, foreign_key: true
      t.references :collection, foreign_key: true

      t.timestamps
    end
  end
end
