class Pocket < ApplicationRecord

  enum state: %i[Unweighed Weighed Classified]

  belongs_to :organization
  belongs_to :collection

  validates :serial_number, presence: true

  class << self
    def unclassified
      where(state: %w[Unweighed Weighed])
    end
  end
end
