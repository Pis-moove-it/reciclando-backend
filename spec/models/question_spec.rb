require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { build(:question) }

  describe 'validations' do
    after(:each) { expect(question).not_to be_valid }

    it 'is not valid without question' do
      question.question = nil
    end

    it 'is not valid without option a' do
      question.option_a = nil
    end

    it 'is not valid without option b' do
      question.option_b = nil
    end

    it 'is not valid without option c' do
      question.option_c = nil
    end

    it 'is not valid without option d' do
      question.option_d = nil
    end

    it 'is not valid without correct option' do
      question.correct_option = nil
    end
  end

  describe 'serializer' do
    let(:serializer) { QuestionSerializer }

    it 'does return what is expected when using the serializer' do
      expect(serializer.new(question).attributes.keys).to eql %i[id question
                                                                 option_a option_b
                                                                 option_c option_d
                                                                 correct_option]
    end
  end
end
