class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :device_id
      t.string :device_type
      t.string :auth_token

      t.timestamps
    end
    add_index :devices, :auth_token, unique: true
  end
end
