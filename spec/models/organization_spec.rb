require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    let(:organization) { FactoryBot.build(:organization) }

    it 'should let create new ones, with appropiate data' do
      expect(organization). to be_valid
    end

    it 'should not let create new ones, with nil name value' do
      organization.name = nil
      expect(organization).not_to be_valid
    end
  end
end
