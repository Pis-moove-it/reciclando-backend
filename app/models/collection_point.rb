class CollectionPoint < ApplicationRecord
  validates :latitude, :longitude, :type, presence: true
  validates :kg_recycled_glass, :kg_recycled_plastic, :kg_trash, numericality: { greater_than_or_equal_to: 0 }

  has_many :collections, dependent: :nullify

  before_validation(on: :create) do
    self.status = 'Ok' if status.nil? && type.eql?('Container')
  end

  def classify(kg_trash, kg_plastic, kg_glass)
    self.kg_trash += kg_trash
    self.kg_recycled_plastic += kg_plastic
    self.kg_recycled_glass += kg_glass
    save
  end
end
