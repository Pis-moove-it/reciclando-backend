require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }

  describe 'GET #index' do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:user) { FactoryBot.create(:user, organization: organization) }

    context 'Success cases' do
      def users_from_organization
        get :index, params: { organization_id: organization.id }
      end

      before(:each) { users_from_organization }

      it 'should return success' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return all users from an organization' do
        expect(json_response.count).to eql 1
      end
    end

    context 'Failure cases' do
      it 'should not find an organization if organization_id does not exist' do
        get :index, params: { organization_id: '985741254' }
        # 404 <- not found
        expect(response).to have_http_status(404)
      end
    end
  end
end
