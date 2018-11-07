require 'rails_helper'
RSpec.describe EventsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let!(:organization) { create(:organization) }
  let!(:serial_numbers) { %w[B03 B17 B59].collect { |sn| { serial_number: sn } } }

  let(:event_params) { attributes_for(:event) }

  let!(:e_serializer){ EventSerializer }

  describe 'POST #create' do
    def create_event_call(route_id, latitude, longitude, description, pocket_attributes)
      post :create, params: { route_id: route_id,
                              event: { latitude: latitude, longitude: longitude, description: description },
                              collection: { pockets_attributes: pocket_attributes } }
    end

    context 'when the user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:auth_route) { create(:route, user: auth_user) }
      let(:invalid_route_id) { Route.pluck(:id).max + 1 }

      context 'when creating valid events and collections' do
        def get_serial_numbers(json_response)
          json_response[:collections].first[:pockets].collect { |p| p.extract!(:serial_number) }
        end

        before(:each) do
          create_event_call(auth_route.id, event_params[:latitude], event_params[:longitude],
                            event_params[:description], serial_numbers)
        end

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return correct event attributes' do
          %i[latitude longitude description].each do |event_param|
            expect(json_response[event_param]).to eql event_params[event_param]
          end
        end

        it 'does return correct route_id for collections' do
          expect(json_response[:collections].first[:route_id]).to eql auth_route.id
        end

        it 'does return correct pocket ammont' do
          expect(json_response[:collections].first[:pockets].count).to eql 3
        end

        it 'does return correct pocket serial_numbers' do
          expect(get_serial_numbers(json_response)).to eql serial_numbers
        end
      end

      context 'when creating invalid collections' do
        it 'does not create collection without route_id' do
          create_event_call(invalid_route_id, event_params[:latitude], event_params[:longitude],
                            event_params[:description], serial_numbers)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create a collection with empty pocket_serial_numbers' do
          create_event_call(auth_route.id, event_params[:latitude], event_params[:longitude],
                            event_params[:description], [])
          expect(response).to have_http_status(:internal_server_error)
        end
      end

      context 'when creating invalid events' do
        it 'does not create event without latitude' do
          create_event_call(auth_route.id, nil, event_params[:longitude],
                            event_params[:description], serial_numbers)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create event without longitude' do
          create_event_call(auth_route.id, event_params[:latitude], nil,
                            event_params[:description], serial_numbers)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create event without description' do
          create_event_call(auth_route.id, event_params[:latitude], event_params[:longitude],
                            nil, serial_numbers)
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when the user is not authenticated' do
      let!(:no_auth_user) { create(:user, organization: organization) }
      let!(:no_auth_route) { create(:route, user: no_auth_user) }
      before(:each) do
        create_event_call(no_auth_route.id, event_params[:latitude], event_params[:longitude],
                          event_params[:description], serial_numbers)
      end
      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
