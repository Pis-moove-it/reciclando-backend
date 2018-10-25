class Container < CollectionPoint
  enum status: %i[Ok Damaged Removed]
  validates :status, :active, presence: true

  before_validation(on: :create) do
    self.active = true
  end

  class << self
    def available
      where(status: %w[Ok Damaged], active: true)
    end
  end
end
