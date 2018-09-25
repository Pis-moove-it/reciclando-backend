class AddOrganizationToPockets < ActiveRecord::Migration[5.2]
  def change
    add_reference :pockets, :organization, foreign_key: true
  end
end
