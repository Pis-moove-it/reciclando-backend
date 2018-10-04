class AddDefaultToContainersActive < ActiveRecord::Migration[5.2]
  def change
    change_column :containers, :active, :boolean, default: true
  end
end
