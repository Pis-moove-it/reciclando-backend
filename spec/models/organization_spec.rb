require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    let(:organization) { FactoryBot.build(:organization) }

    context 'when create organizations with appropiate data' do
      it 'does let create new ones' do
        expect(organization). to be_valid
      end
    end

    context 'when create organizations with wrong values' do
      it 'does not create new ones without name' do
        organization.name = nil
        expect(organization).not_to be_valid
      end

      it 'does not create new ones without password' do
        organization.password = nil
        expect(organization).not_to be_valid
      end
    end
  end
end
