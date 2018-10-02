require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_keys: true) }
  let!(:organization) { FactoryBot.create(:organization) }
  let!(:collection_point) { FactoryBot.create(:collection_point) }

  describe 'POST #create' do
    def create_collection_call(r_id, cp_id, serials)
      post :create, params: { route_id: r_id,
                              collection: { collection_point_id: cp_id, pocket_serial_numbers: serials } }
    end

<<<<<<< HEAD
    context 'when creating valid collections' do
      it 'does return success' do
        create_collection_call(route.id, collection_point.id, %w[B03 B17 B59])
        expect(response).to have_http_status(:ok)
      end
    end
=======
    context 'when the user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:auth_route) { FactoryBot.create(:route, user: auth_user) }
      let(:invalid_route_id) { Route.pluck(:id).max + 1 }
>>>>>>> Collection controller test now test if the user is authenticated or not. Authentication added to addPocket

      context 'when creating valid collections' do
        it 'does return success' do
          create_collection_call(auth_route.id, collection_point.id, %w[B03 B17 B59])
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when creating invalid collections' do
        it 'does not create a collection without route_id' do
          create_collection_call(invalid_route_id, collection_point.id, %w[B09 B33])
          expect(response).to have_http_status(:not_found)
        end
        it 'does not create a collection without collection_point_id' do
          create_collection_call(auth_route.id, nil, %w[B11])
          expect(response).to have_http_status(:bad_request)
        end
        it 'does not create a collection without pocket_serial_numbers' do
          create_collection_call(auth_route.id, collection_point.id, nil)
          expect(response).to have_http_status(:internal_server_error)
        end
        it 'does not create a collection with empty pocket_serial_numbers' do
          create_collection_call(auth_route.id, collection_point.id, [])
          expect(response).to have_http_status(:internal_server_error)
        end
      end
    end

    context 'when the user is not authenticated' do
      let!(:no_auth_user) { FactoryBot.create(:user, organization: organization) }
      let!(:no_auth_route) { FactoryBot.create(:route, user: no_auth_user) }

      before(:each) { create_collection_call(no_auth_route.id, collection_point.id, %w[B03 B17 B59]) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response['error_code']).to eql 2
      end
    end
  end
end
