class Pocket < ApplicationRecord
  enum state: %i[Unweighed Weighed Classified]

  belongs_to :organization
  belongs_to :collection

  validates :serial_number, presence: true
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0.001 }, unless: :unweighed?
  validates :kg_trash, :kg_recycled_plastic, :kg_recycled_glass,
            numericality: { greater_than: 0 }, allow_nil: true

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

  def classify(total_weight, kg_trash, kg_plastic, kg_glass)
    percentage = weight / total_weight.to_f
    self.kg_trash = kg_trash * percentage
    self.kg_recycled_plastic = kg_plastic * percentage
    self.kg_recycled_glass = kg_glass * percentage
    self.state = 'Classified'
  end
end
