require 'rails_helper'

RSpec.describe RoutesController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let!(:organization) { create(:organization) }
  let(:r_serializer) { RouteSerializer }

  describe 'POST #create' do
    def create_route_call
      post :create
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
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
      put :update, params: { id: route_id, length: length, travel_image: travel_image }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:route) { create(:route, user: auth_user) }

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

        it 'does check in pockets' do
          route.reload

          route.collections.each do |collection|
            collection.pockets.each do |pocket|
              expect(pocket.check_in).not_to eql nil
            end
          end
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

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
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

      context 'when the route is from another organization' do
        let!(:another_organization) { create(:organization) }
        let!(:another_user) { create(:user, organization: another_organization) }
        let!(:another_route) { create(:route, user: another_user) }

        before(:each) { end_route_call(another_route.id, ended_route[:length], ended_route[:travel_image]) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does render the right error' do
          expect(json_response[:error_code]).to eql 3
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

  describe 'GET #show' do
    def get_routes_call(id)
      get :show, params: { id: id }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:route) { create(:route, user: auth_user) }

      context 'when the route exists' do
        before(:each) { get_routes_call(route.id) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the route as specified in the serializer' do
          expect(json_response).to eql r_serializer.new(route).as_json
        end
      end

      context 'when the route does not exist' do
        before(:each) { get_routes_call(Route.pluck(:id).max + 1) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does render the right error' do
          expect(json_response[:error_code]).to eql 3
        end
      end

      context 'when the route is from another organization' do
        let!(:another_organization) { create(:organization) }
        let!(:another_user) { create(:user, organization: another_organization) }
        let!(:another_route) { create(:route, user: another_user) }

        before(:each) { get_routes_call(another_route.id) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does render the right error' do
          expect(json_response[:error_code]).to eql 3
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }
      let!(:route) { create(:route, user: user) }

      before(:each) { get_routes_call(route.id) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'GET #index' do
    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let(:another_organization) { create(:organization) }
      let!(:another_user) { create(:user, organization: another_organization) }

      let!(:route) { create(:route, user: auth_user) }
      let!(:another_route) { create :route, user: another_user }

      before(:each) { get :index }

      context 'when listing all the routes from the organization' do
        it 'does return succes' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the route as specified in the serializer' do
          expect(json_response).to eql [r_serializer.new(route).as_json]
        end

        it 'does not return routes from another organization' do
          expect(json_response.pluck(:id)).not_to include(another_route.id)
        end
      end
    end

    context 'when user is not authenticated' do
      before(:each) { get :index }

      it 'does return an error' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
