class Bale < ApplicationRecord
  enum material: %i[Trash Plastic Glass]
end
