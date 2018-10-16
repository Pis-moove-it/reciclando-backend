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

  describe 'PUT #update' do
    let(:ended_route) { build(:ended_route) }

    def end_route_call(route_id, length, travel_image)
      put :update, params: { id: route_id, route: { length: length, travel_image: travel_image } }, as: :json
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:route) { create(:route, user: auth_user) }

      let(:r_serializer) { RouteSerializer }

      context 'when inputs are valid' do
        before(:each) { end_route_call(route.id, ended_route[:length], ended_route[:travel_image]) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does update the route' do
          route.reload
          expect([route.length, route.travel_image]).to eql [ended_route[:length], ended_route[:travel_image]]
        end

        it 'does return the route as specified in the serializer' do
          expect(json_response).to eql r_serializer.new(route.reload).as_json
        end
      end

      context 'when length is missing' do
        before(:each) { end_route_call(route.id, nil, ended_route[:travel_image]) }

        it 'does return the right error' do
          expect(response).to have_http_status(400)
        end

        it 'does return missing length' do
          expect(json_response[:details]).to eql 'Missing length'
        end
      end

      context 'when length is negative' do
        before(:each) { end_route_call(route.id, -13, ended_route[:travel_image]) }

        it 'does return the right error' do
          expect(response).to have_http_status(400)
        end

        it 'does return negative length' do
          expect(json_response[:details]).to eql 'Negative length'
        end
      end

      context 'when travel image is missing' do
        before(:each) { end_route_call(route.id, ended_route[:length], nil) }

        it 'does return the right error' do
          expect(response).to have_http_status(400)
        end

        it 'does return missing travel image' do
          expect(json_response[:details]).to eql 'Missing travel image'
        end
      end

      context 'when route is ended' do
        let(:another_ended_route) { create(:ended_route, user: auth_user) }

        before(:each) { end_route_call(another_ended_route.id, ended_route[:length], ended_route[:travel_image]) }

        it 'does return the right error' do
          expect(response).to have_http_status(400)
        end

        it 'does return route ended' do
          expect(json_response[:details]).to eql 'Route already ended'
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }
      let!(:route) { create(:route, user: user) }

      before(:each) { end_route_call(route.id, ended_route[:length], ended_route[:travel_image]) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
