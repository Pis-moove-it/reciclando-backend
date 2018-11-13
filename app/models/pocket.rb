class Pocket < ApplicationRecord
  enum state: %i[Unweighed Weighed Classified]

  belongs_to :organization
  belongs_to :collection

  validates :serial_number, presence: true
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0.001 }, unless: :unweighed?
  validates :kg_trash, :kg_recycled_plastic, :kg_recycled_glass,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  delegate :organization, to: :collection

  before_validation(on: :create) do
    self.organization = organization
  end

  class << self
    def unclassified
      where(state: %w[Unweighed Weighed])
    end

    def unclassified_and_checked_in
      unclassified.where.not(check_in: nil)
    end

    def weighed
      where(state: 'Weighed')
    end

    def unweighed
      where(state: 'Unweighed')
    end

    def classified
      where(state: 'Classified')
    end

    def monthly(month)
      where(created_at: month.to_time(:utc).beginning_of_month..
                        month.to_time(:utc).end_of_month)
    end
  end

  def classify(total_weight, kg_trash, kg_plastic, kg_glass)
    percentage = weight / total_weight.to_f
    self.kg_trash = kg_trash * percentage
    self.kg_recycled_plastic = kg_plastic * percentage
    self.kg_recycled_glass = kg_glass * percentage
    self.state = 'Classified'
  end

  private

  def unweighed?
    self.Unweighed?
  end
end
