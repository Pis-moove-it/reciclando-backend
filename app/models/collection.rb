class Collection < ApplicationRecord
  belongs_to :route
  belongs_to :collection_point

  has_many :pockets, dependent: :destroy

  delegate :organization, to: :route

  accepts_nested_attributes_for :pockets
end
