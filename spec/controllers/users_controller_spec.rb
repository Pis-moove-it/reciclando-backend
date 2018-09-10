require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'get #index' do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:user) { FactoryBot.create(:user, organization: organization) }
    it 'should return all users from an organization succesfully' do
      get :index, params: { organization_id: organization.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
