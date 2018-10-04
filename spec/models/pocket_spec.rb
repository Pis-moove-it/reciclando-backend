require 'rails_helper'

RSpec.describe Pocket, type: :model do
  let!(:organization) { create(:organization) }

  describe 'serializer' do
    let!(:pocket) { FactoryBot.create(:pocket, organization: organization) }
    let(:serializer) { PocketSerializer }

    it 'does return pockets as specified in the serializer' do
      expect(serializer.new(pocket).attributes.keys).to eq %i[id serial_number state]
    end
  end

  describe 'validations' do
    let(:pocket) { build(:pocket, organization: organization) }

    it 'is valid with valid attributes' do
      expect(pocket).to be_valid
    end

    it 'is not valid without serial number' do
      pocket.serial_number = nil
      expect(pocket).not_to be_valid
    end
  end
end
