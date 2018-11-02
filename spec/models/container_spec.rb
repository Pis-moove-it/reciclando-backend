require 'rails_helper'

RSpec.describe Container, type: :model do
  let!(:organization) { create(:organization) }
  let!(:container) { create(:container, organization: organization) }
  let(:c_serializer) { ContainerSerializer }
  let(:web_serializer) { ContainerWebSerializer }
  describe 'validations' do
    context 'when create containers with appropiate data' do
      it 'does let create new ones' do
        expect(container).to be_valid
      end
    end

    context 'when create container with wrong values' do
      it 'does not let create new ones, nil latitude value' do
        container.latitude = nil
        expect(container).not_to be_valid
      end
      it 'does not let create new ones, nil longitude value' do
        container.longitude = nil
        expect(container).not_to be_valid
      end
      it 'does not let create new ones, nil status value' do
        container.status = nil
        expect(container).not_to be_valid
      end
      it 'does not let create new ones, nil active value' do
        container.active = nil
        expect(container).not_to be_valid
      end
      it 'does not let create new ones, nil organization' do
        container.organization = nil
        expect(container).not_to be_valid
      end
    end
  end

  describe 'serializer' do
    let!(:container) { create(:container, organization: organization) }

    it 'does return containers, as specified in the main serializer' do
      expect(c_serializer.new(container).attributes.keys).to eq %i[id latitude longitude status]
    end

    it 'does return containers, as specified in the web serializer' do
      expect(web_serializer.new(container).attributes.keys).to eq %i[id latitude longitude status kg_trash
                                                                     kg_recycled_glass kg_recycled_plastic]
    end
  end
end
