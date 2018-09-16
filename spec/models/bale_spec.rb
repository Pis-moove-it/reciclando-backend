require 'rails_helper'

RSpec.describe Bale, type: :model do
  let!(:bale) { FactoryBot.create(:bale) }
  let(:b_serializer) { BaleSerializer }
  describe 'validations' do
    it 'should let create new ones, with appropiate data' do
      expect(bale).to be_valid
    end

    it 'should not let create new ones, with nil weight value' do
      bale.weight = nil
      expect(bale).not_to be_valid
    end

    it 'should not let create new ones, with nil material value' do
      bale.material = nil
      expect(bale).not_to be_valid
    end
  end

  describe 'serializer' do
    it 'should return bales, as specified in the serializer' do
      expect(b_serializer.new(bale).attributes.keys).to eq %i[id weight material]
    end
  end
end
