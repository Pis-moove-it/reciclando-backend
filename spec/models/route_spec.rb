require 'rails_helper'

RSpec.describe Route, type: :model do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let(:r_serializer) { RouteSerializer }

  describe 'validations' do
    context 'when create routes with appropiate data' do
      it 'does let create new ones' do
        expect(route).to be_valid
      end
    end

    context 'when create routes with wrong values' do
      let(:negative_length) { Faker::Number.negative.to_i }

      it 'does not let create new ones without user' do
        route.user = nil
        expect(route).not_to be_valid
      end

      it 'does not let create new ones with an invalid length' do
        route.length = 0
        expect(route).not_to be_valid
      end

      it 'does not let create new ones with an invalid length' do
        route.length = negative_length
        expect(route).not_to be_valid
      end
    end
  end

  describe 'serializer' do
    it 'does return routes, as specified in the serializer' do
      expect(r_serializer.new(route).attributes.keys).to eq %i[id length travel_image created_at]
      expect(r_serializer.new(route).associations.map(&:key)).to eq %i[user pockets]
    end
  end

  describe 'callback' do
    context 'when updating a route' do
      let(:collections) { route.collections }
      before(:each) { route.update(length: Faker::Number.number(2)) }

      it 'does update pockets check in' do
        collections.each do |collection|
          collection.pockets.each do |pocket|
            expect(pocket.check_in).not_to eql nil
          end
        end
      end
    end
  end
end
