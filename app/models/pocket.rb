class Pocket < ApplicationRecord
  enum state: %i[Unweighed Weighed Classified]
  validates :state, presence: true

  belongs_to :organization

  has_many :collection_pockets, dependent: :destroy
  has_many :collections, through: :collection_pockets

  validates :serial_number, presence: true

  class << self
    def unclassified
      where(state: %w[Unweighed Weighed])
    end
  end
end
