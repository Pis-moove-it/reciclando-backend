class AddUserRefToBales < ActiveRecord::Migration[5.2]
  def change
    add_reference :bales, :user, foreign_key: true
  end
end
