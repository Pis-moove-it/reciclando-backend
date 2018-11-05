require 'rails_helper'

RSpec.describe Pocket, type: :model do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let!(:container) { create(:container, organization: organization) }
  let!(:collection) { create(:collection, route: route, collection_point: container) }

  describe 'serializer' do
    let!(:pocket) { create(:pocket, organization: organization, collection: collection) }
    let(:serializer) { PocketSerializer }

    it 'does return pockets as specified in the serializer' do
      expect(serializer.new(pocket).attributes.keys).to eq %i[id serial_number state weight kg_trash
                                                              kg_recycled_plastic kg_recycled_glass check_in]
    end
  end

  describe 'validations' do
    let(:pocket) { build(:pocket, organization: organization, collection: collection) }
    let(:negative_weight) { Faker::Number.negative }

    it 'is valid with valid attributes' do
      expect(pocket).to be_valid
    end

    it 'is not valid without serial number' do
      pocket.serial_number = nil
      expect(pocket).not_to be_valid
    end

    it 'is not valid when the pocket is weighed and weight is 0' do
      pocket.state = 'Weighed'
      pocket.weight = 0
      expect(pocket).not_to be_valid
    end

    it 'is not valid when the pocket is weighed and has negative weight' do
      pocket.state = 'Weighed'
      pocket.weight = negative_weight
      expect(pocket).not_to be_valid
    end

    it 'is not valid with a negative kg_trash' do
      pocket.kg_trash = negative_weight
      expect(pocket).not_to be_valid
    end

    it 'is not valid with a negative kg_recycled_plastic' do
      pocket.kg_recycled_plastic = negative_weight
      expect(pocket).not_to be_valid
    end

    it 'is not valid with a negative kg_recycled_glass' do
      pocket.kg_recycled_glass = negative_weight
      expect(pocket).not_to be_valid
    end
  end

  describe 'functions' do
    let(:pocket) { build(:weighed_pocket, organization: organization, collection: collection) }

    describe '#classify' do
      describe 'with valid parameters' do
        let!(:kg_trash) { Faker::Number.decimal(2, 2).to_f }
        let!(:kg_plastic) { Faker::Number.decimal(2, 2).to_f }
        let!(:kg_glass) { Faker::Number.decimal(2, 2).to_f }

        let!(:total_weight) { kg_trash + kg_plastic + kg_glass }
        let!(:percentage) { pocket.weight / total_weight.to_f }

        before(:each) { pocket.classify(total_weight, kg_trash, kg_plastic, kg_glass) }

        it 'does be valid' do
          expect(pocket).to be_valid
        end

        it 'does has correct kg_trash' do
          expect(pocket.kg_trash).to eql(percentage * kg_trash)
        end

        it 'does has correct kg_recycled_plastic' do
          expect(pocket.kg_recycled_plastic).to eql(percentage * kg_plastic)
        end

        it 'does has correct kg_recycled_glass' do
          expect(pocket.kg_recycled_glass).to eql(percentage * kg_glass)
        end

        it 'does be classified' do
          expect(pocket.state).to eql 'Classified'
        end
      end
    end
  end
end
