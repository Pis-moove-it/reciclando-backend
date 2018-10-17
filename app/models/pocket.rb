class Pocket < ApplicationRecord
  enum state: %i[Unweighed Weighed Classified]

  belongs_to :organization
  belongs_to :collection

  validates :serial_number, presence: true

  delegate :organization, to: :collection

  before_validation(on: :create) do
    self.organization = organization
  end

  class << self
    def unclassified
      where(state: %w[Unweighed Weighed])
    end
  end
end
