require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET #index' do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:user) { FactoryBot.create(:user, organization: organization) }
    let(:u_serializer) { UserSerializer }

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

      it 'should return users, as specified in the serializer' do
        expect(json_response).to eq [u_serializer.new(user).as_json]
      end
    end

    context 'Failure cases' do
      it 'should not find an organization if organization_id does not exist' do
        get :index, params: { organization_id: User.pluck(:id).max + 1 }
        expect(response).to have_http_status(404)
        expect(json_response[:error_code]).to eq 3
      end
    end
  end

  describe 'GET #show' do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:user) { FactoryBot.create(:user, organization: organization) }
    let(:u_serializer) { UserSerializer }

    def user_from_organization_call(organization_id, user_id)
      get :show, params: { organization_id: organization_id, id: user_id }
    end

    context 'success cases' do
      before(:each) { user_from_organization_call(organization.id, user.id) }

      it 'should return success' do
        expect(response).to have_http_status(200)
      end

      it 'should return the user' do
        expect(json_response).to eql u_serializer.new(user).as_json
      end
    end

    context 'failure cases' do
      it 'should return an error if the organization doesnt exist' do
        user_from_organization_call(Organization.pluck(:id).max + 1, user.id)

        expect(response).to have_http_status(404)
        expect(json_response[:error_code]).to eql 3
      end

      it 'should return an error if the user doesnt exist' do
        user_from_organization_call(organization.id, User.pluck(:id).max + 1)

        expect(response).to have_http_status(404)
        expect(json_response[:error_code]).to eql 3
      end
    end
  end
end
