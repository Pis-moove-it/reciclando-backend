require 'rails_helper'

RSpec.describe Bale, type: :model do
  describe 'validations' do
    let!(:bale) { FactoryBot.create(:bale) }
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
end
