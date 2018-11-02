class Collection < ApplicationRecord
  belongs_to :route
  belongs_to :collection_point

  has_many :pockets, dependent: :destroy

  delegate :organization, to: :route, allow_nil: true

  accepts_nested_attributes_for :pockets

  def check_in_pockets
    byebug
    pockets.update(check_in: Time.current)
  end
end
