require 'rails_helper'

RSpec.describe Container, type: :model do
  let!(:container) { FactoryBot.create(:container) }
  let(:c_serializer) { ContainerSerializer }
  describe 'validations' do
    context 'when create containers with appropiate data' do
      it 'does let create new ones' do
        expect(container).to be_valid
      end
    end

    context 'when create container with wrong values' do
      it 'does not let create new ones, nil status value' do
        container.status = nil
        expect(container).not_to be_valid
      end
      it 'does not let create new ones, nil active value' do
        container.active = nil
        expect(container).not_to be_valid
      end
    end
  end
end
