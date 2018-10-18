require 'rails_helper'

RSpec.describe Collection, type: :model do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let!(:collection_point) { create(:collection_point) }
  let!(:pocket) { build(:pocket, organization: organization) }
  let!(:collection) { create(:collection, route: route, collection_point: collection_point, pockets: [pocket]) }

  describe 'serializer' do
    let(:serializer) { CollectionSerializer }

    it 'does return pockets as specified in the serializer' do
      expect(serializer.new(collection).attributes.keys).to eq %i[id collection_point_id route_id]
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(collection).to be_valid
    end

    it 'is not valid without a route' do
      collection.route = nil
      expect(collection).not_to be_valid
    end

    it 'is not valid without a collection_point' do
      collection.collection_point = nil
      expect(collection).not_to be_valid
    end
  end
end
