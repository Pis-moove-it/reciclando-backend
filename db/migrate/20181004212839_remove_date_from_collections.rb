class RemoveDateFromCollections < ActiveRecord::Migration[5.2]
  def change
    remove_column :collections, :date, :datetime
  end
end
