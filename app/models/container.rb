class Container < ApplicationRecord

  enum status: %i[Ok Damaged Removed]
  validates :status, presence: true
end
