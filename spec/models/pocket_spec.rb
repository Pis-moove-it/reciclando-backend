require 'rails_helper'

RSpec.describe Pocket, type: :model do
  let!(:organization) { create(:organization) }
  let!(:pocket) { FactoryBot.create(:pocket, organization: organization) }
  let(:serializer) { PocketSerializer }

  describe 'serializer' do
    it 'does return pockets as specified in the serializer' do
      expect(serializer.new(pocket).attributes.keys).to eq %i[id serial_number state]
    end
  end
end
