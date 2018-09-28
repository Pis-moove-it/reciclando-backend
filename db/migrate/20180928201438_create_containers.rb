class CreateContainers < ActiveRecord::Migration[5.2]
  def change
    create_table :containers do |t|
      t.integer :status
      t.boolean :active

      t.timestamps
    end
  end
end
