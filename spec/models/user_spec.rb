require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let!(:organization) { FactoryBot.build(:organization) }
    let!(:user) { FactoryBot.build(:user, organization: organization) }

    it 'should let create new ones, with appropiate data' do
      expect(user). to be_valid
    end

    it 'should not let create new ones, with nil ci value' do
      user.ci = nil
      expect(user).not_to be_valid
    end

    #it 'should not let create new ones, with ci value already taken' do
#
 #   end

  #  it 'should not let create new ones, with email value already taken' do
#
 #   end
  end
end
