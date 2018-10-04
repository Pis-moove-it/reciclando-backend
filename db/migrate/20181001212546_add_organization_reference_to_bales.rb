class AddOrganizationReferenceToBales < ActiveRecord::Migration[5.2]
  def change
    add_reference :bales, :organization, foreign_key: true
  end
end
