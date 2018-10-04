class AddPasswordToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :password_digest, :string
  end
end
