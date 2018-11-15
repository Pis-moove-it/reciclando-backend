class Question < ApplicationRecord
  enum correct_option: %w[A B C D]
  validates :question, :option_a, :option_b, :option_c, :option_d, :correct_option, presence: true
end
