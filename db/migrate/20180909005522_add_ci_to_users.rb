class AddCiToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ci, :string
  end
end
