class AddForeignKeysToDevices < ActiveRecord::Migration[5.2]
  def change
    add_reference :devices, :user, foreign_key: true
    add_reference :devices, :organization, foreign_key: true
  end
end
