class Collection < ApplicationRecord
  belongs_to :route
  belongs_to :collection_point

  has_many :collection_pockets, dependent: :destroy
  has_many :pockets, through: :collection_pockets
end
