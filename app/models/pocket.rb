class Pocket < ApplicationRecord
  enum state: %i[Unweighed Weighed Classified]

  belongs_to :organization
  belongs_to :collection

  validates :serial_number, presence: true
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0.001 }, unless: :unweighed?

  delegate :organization, to: :collection

  before_validation(on: :create) do
    self.organization = organization
  end

  class << self
    def unclassified
      where(state: %w[Unweighed Weighed])
    end
  end

  private

  def unweighed?
    self.Unweighed?
  end
end
