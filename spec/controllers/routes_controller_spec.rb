require 'rails_helper'

RSpec.describe RoutesController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let!(:organization) { create(:organization) }

  describe 'POST #create' do
    def create_route_call
      post :create
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let(:r_serializer) { RouteSerializer }
      before(:each) { create_route_call }

      it 'does return success' do
        expect(response).to have_http_status(:ok)
      end

      it 'does create only one route' do
        expect(Route.count).to eql 1
      end

      it 'does return the route as specified in the serializer' do
        expect(json_response).to eql r_serializer.new(Route.first).as_json
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }

      before(:each) { create_route_call }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
