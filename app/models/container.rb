class Container < CollectionPoint
  enum status: %i[Ok Damaged Removed]
  validates :status, :kg_trash, :kg_recycled_plastic, :kg_recycled_glass, presence: true
  validates :active, exclusion: { in: [nil] }

  has_many :collections, dependent: :nullify

  belongs_to :organization

  before_validation(on: :create) do
    self.active = true if active.nil?
  end

  class << self
    def available
      where(status: %w[Ok Damaged], active: true)
    end
  end
end
