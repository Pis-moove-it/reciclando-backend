require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  let!(:organization) { create(:organization) }
  let(:u_serializer) { UserSerializer }

  describe 'GET #index' do
    let!(:user) { FactoryBot.create(:user, organization: organization) }

    context 'when listing users' do
      def users_from_organization
        get :index, params: { organization_id: organization.id }
      end

      before(:each) { users_from_organization }

      it 'does return success' do
        expect(response).to have_http_status(:ok)
      end

      it 'does return all users from an organization' do
        expect(json_response.count).to eql 1
      end

      it 'does return users as specified in the serializer' do
        expect(json_response).to eq [u_serializer.new(user).as_json]
      end
    end

    context 'when organization does not exist' do
      it 'does return not found' do
        get :index, params: { organization_id: User.pluck(:id).max + 1 }
        expect(response).to have_http_status(404)
        expect(json_response[:error_code]).to eq 3
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { FactoryBot.create(:user, organization: organization) }

    def user_from_organization_call(organization_id, user_id)
      get :show, params: { organization_id: organization_id, id: user_id }
    end

    context 'when shows valid users' do
      before(:each) { user_from_organization_call(organization.id, user.id) }
      it 'does return success' do
        expect(response).to have_http_status(200)
      end
      it 'does return the user' do
        expect(json_response).to eql u_serializer.new(user).as_json
      end
    end

    context 'when organization does not exist' do
      it 'does return not found' do
        user_from_organization_call(Organization.pluck(:id).max + 1, user.id)
        expect(response).to have_http_status(404)
        expect(json_response[:error_code]).to eql 3
      end
    end

    context 'when shows invalid users' do
      it 'does return not found' do
        user_from_organization_call(organization.id, User.pluck(:id).max + 1)
        expect(response).to have_http_status(404)
        expect(json_response[:error_code]).to eql 3
      end
    end
  end

  describe 'POST #login' do
    def user_login_call(organization_id, user_id)
      post :login, params: { organization_id: organization_id, id: user_id }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      before(:each) { user_login_call(organization.id, auth_user.id) }

      it 'does return success' do
        expect(response).to have_http_status(200)
      end

      it 'does return the user' do
        expect(json_response).to eql u_serializer.new(auth_user).as_json
      end

      it 'does associate the user with the device' do
        expect(Device.count).to eql 1
        expect(json_response[:id]).to eql Device.first.user.id
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }

      before(:each) { user_login_call(organization.id, user.id) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
