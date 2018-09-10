class CreateBales < ActiveRecord::Migration[5.2]
  def change
    create_table :bales do |t|
      t.float :weight
      t.integer :material

      t.timestamps
    end
  end
end
