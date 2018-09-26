class CollectionPoint < ApplicationRecord
  has_many :collections, dependent: :nullify
end
