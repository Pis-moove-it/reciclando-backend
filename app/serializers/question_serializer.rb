class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :question, :option_a, :option_b, :option_c, :option_d, :correct_option
end
