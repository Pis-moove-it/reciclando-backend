class CreatePockets < ActiveRecord::Migration[5.2]
  def change
    create_table :pockets do |t|
      t.string :serial_number
      t.integer :state

      t.timestamps
    end
  end
end
