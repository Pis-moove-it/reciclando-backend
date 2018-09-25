class Pocket < ApplicationRecord
  enum state: %i[Unweighed Weighed Classified]

  belongs_to :organization

  has_many :collection_pockets, dependent: :destroy
  has_many :collections, through: :collection_pockets
end
