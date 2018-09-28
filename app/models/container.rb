class Container < ApplicationRecord
  enum status: %i[Ok Damaged Removed]
  validates :status, :active, presence: true
end
