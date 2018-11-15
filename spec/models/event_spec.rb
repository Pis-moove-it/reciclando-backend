require 'rails_helper'

RSpec.describe Event, type: :model do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let!(:event) { create(:event) }
  let!(:collection) { create(:collection_with_pockets, collection_point: event, route: route) }
  let!(:e_serializer) { EventSerializer }
  describe 'validations' do
    context 'when create events with appropiate data' do
      it 'does let create new ones' do
        expect(event).to be_valid
      end
    end

    context 'when create event with wrong values' do
      it 'does not let create new ones, nil latitude value' do
        event.latitude = nil
        expect(event).not_to be_valid
      end
      it 'does not let create new ones, nil longitude value' do
        event.longitude = nil
        expect(event).not_to be_valid
      end
      it 'does not let create new ones, nil description value' do
        event.description = nil
        expect(event).not_to be_valid
      end
      it 'does not let create new ones, nil kg_trash' do
        event.kg_trash = nil
        expect(event).not_to be_valid
      end

      it 'does not let create new ones, nil kg_recycled_plastic' do
        event.kg_recycled_plastic = nil
        expect(event).not_to be_valid
      end

      it 'does not let create new ones, nil kg_recycled_glass' do
        event.kg_recycled_glass = nil
        expect(event).not_to be_valid
      end
    end
  end

  describe 'serializer' do
    it 'does return events, as specified in the main serializer' do
      expect(e_serializer.new(event).attributes.keys).to eq %i[id latitude longitude description]
    end
  end
end
