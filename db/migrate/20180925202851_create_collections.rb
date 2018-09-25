class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.integer :pocket_weigth
      t.datetime :date

      t.timestamps
    end
  end
end
