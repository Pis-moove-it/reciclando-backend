require 'rails_helper'

RSpec.describe Bale, type: :model do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:bale) { create(:bale, organization: organization, user: user) }
  let(:b_serializer) { BaleSerializer }

  describe 'validations' do
    context 'when create bales with appropiate data' do
      it 'does let create new ones' do
        expect(bale).to be_valid
      end
    end

    context 'when create bales with wrong values' do
      it 'does not let create new ones, nil weight value' do
        bale.weight = nil
        expect(bale).not_to be_valid
      end

      it 'does not let create new ones, nil material value' do
        bale.material = nil
        expect(bale).not_to be_valid
      end

      it 'does not let create new ones without user' do
        bale.user = nil
        expect(bale).not_to be_valid
      end
    end
  end

  describe 'serializer' do
    it 'does return bales, as specified in the serializer' do
      expect(b_serializer.new(bale).attributes.keys).to eq %i[id weight material]
    end
  end
end
