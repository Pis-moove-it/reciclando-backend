require 'rails_helper'
RSpec.describe EventsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_keys: true) }
  let!(:organization) { create(:organization) }
  let!(:serial_numbers) { %w[B03 B17 B59].collect { |sn| { serial_number: sn } } }
  let(:event) { create(:event) }

  describe 'POST #create' do
    let(:collection_params) { attributes_for(:collection) }

    def create_event_call(route_id, latitude, longitude, description, pocket_attributes)
      post :create, params: { route_id: route_id,
                              event: { latitude: latitude, longitude: longitude, description: description },
                              collection: { pockets_attributes: pocket_attributes } }
    end

    context 'when the user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:auth_route) { create(:route, user: auth_user) }
      let(:invalid_route_id) { Route.pluck(:id).max + 1 }

      before(:each) { create_collection_call(auth_route.id, container.id, serial_numbers) }

      context 'when creating valid collections' do
        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the correct collection_point_id and the route_id' do
          %i[collection_point_id route_id].each do |collection_param|
            expect(json_response[collection_param]).to eql collection_params[collection_param]
          end
        end

        it 'does return pockets with correct serial numbers' do
          expect(json_response['pockets'].collect { |p| p.slice('serial_number').symbolize_keys }).to eql serial_numbers
        end
      end

      context 'when creating invalid collections' do
        it 'does not create a collection without route_id' do
          create_collection_call(invalid_route_id, container.id, serial_numbers)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create a collection without collection_point_id' do
          create_collection_call(auth_route.id, nil, serial_numbers)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create a collection without pocket_serial_numbers' do
          create_collection_call(auth_route.id, container.id, nil)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create a collection with empty pocket_serial_numbers' do
          create_collection_call(auth_route.id, container.id, [])
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when the user is not authenticated' do
      let!(:no_auth_user) { create(:user, organization: organization) }
      let!(:no_auth_route) { create(:route, user: no_auth_user) }
      before(:each) { create_collection_call(no_auth_route.id, container.id, serial_numbers) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response['error_code']).to eql 2
      end
    end
  end
end
