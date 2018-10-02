class AddRouteToCollections < ActiveRecord::Migration[5.2]
  def change
    add_reference :collections, :route, foreign_key: true
  end
end
