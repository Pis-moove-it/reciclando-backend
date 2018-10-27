class AddCheckInToPockets < ActiveRecord::Migration[5.2]
  def change
    add_column :pockets, :check_in, :datetime
  end
end
