class Event < CollectionPoint
  validates :description, presence: true

  has_one :collection, dependent: :destroy
end
