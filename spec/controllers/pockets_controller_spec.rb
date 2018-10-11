require 'rails_helper'

RSpec.describe PocketsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let!(:collection_point) { create(:collection_point) }
  let!(:collection) { create(:collection, route: route, collection_point: collection_point) }
  let!(:organization) { create(:organization) }

  let(:serializer) { PocketSerializer }

  describe 'GET #index' do
    def list_pockets_call
      get :index
    end

    context 'when the user is authenticated' do
      let!(:another_organization) { create(:organization) }
      let!(:another_user) { create(:user, organization: another_organization) }
      let!(:another_route) { create(:route, user: another_user) }
      let!(:collection_point) { create(:collection_point) }
      let!(:another_collection) do
        create(:collection, route: another_route, collection_point: collection_point)
      end

      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      let!(:unclassified_pocket) do
        create(:unclassified_pocket, organization: organization, collection: collection)
      end
      let!(:classified_pocket) do
        create(:classified_pocket, organization: organization, collection: collection)
      end
      let!(:another_unclassified_pocket) do
        create(:unclassified_pocket, organization: another_organization,
                                     collection: another_collection)
      end

      before(:each) { list_pockets_call }

      it 'does return success' do
        expect(response).to have_http_status(200)
      end

      it 'does return all the unclassified pockets' do
        expect(json_response).to eql [serializer.new(unclassified_pocket).as_json]
      end

      it 'does not return the classfied pockets' do
        expect(json_response.pluck(:id)).not_to include classified_pocket.id
      end

      it 'does not return the pockets from another organization' do
        expect(json_response.pluck(:id)).not_to include another_unclassified_pocket.id
      end
    end

    context 'when the user is not authenticated' do
      before(:each) { list_pockets_call }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'PUT #edit_serial_number' do
    let!(:pocket) { create(:pocket, organization: organization, collection: collection) }
    let!(:device) do
      create(:device, device_id: '1', device_type: 'android',
                      organization: organization)
    end

    def edit_serial_number_call(pocket_id, serial_number, token)
      @request.headers['ApiKey'] = token
      put :edit_serial_number, params: { id: pocket_id, serial_number: serial_number }
    end

    context 'when inputs are valid' do
      before(:each) { edit_serial_number_call(pocket.id, '123', device.auth_token) }
      it 'does edit the serial number' do
        expect(json_response[:serial_number]).to eq '123'
      end
      it 'does return ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when ApiKey is missing' do
      it 'does return invalid token' do
        put :edit_serial_number, params: { id: pocket.id, serial_number: '14592' }
        expect(response).to have_http_status(401)
      end
    end

    context 'when pocket id is invalid' do
      it 'does return not found' do
        max_id = Pocket.pluck(:id).max
        edit_serial_number_call(max_id + 1, '14592', device.auth_token)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when serial number is invalid or missing' do
      it 'does return bad request' do
        @request.headers['ApiKey'] = device.auth_token
        put :edit_serial_number, params: { id: pocket.id }
        expect(response).to have_http_status(400)
      end
      it 'does return bad request' do
        @request.headers['ApiKey'] = device.auth_token
        put :edit_serial_number, params: { id: pocket.id, serial_number: '' }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'PUT #edit_weight' do
    let!(:weighed_pocket) do
      create(:weighed_pocket, organization: organization, collection: collection)
    end
    let!(:unweighed_pocket) do
      create(:unweighed_pocket, organization: organization, collection: collection)
    end
    let!(:device) do
      create(:device, device_id: '1', device_type: 'android', organization: organization)
    end

    def edit_weight_call(pocket_id, weight, token)
      @request.headers['ApiKey'] = token
      put :edit_weight, params: { id: pocket_id, weight: weight }, as: :json
    end

    context 'when inputs are valid' do
      before(:each) { edit_weight_call(weighed_pocket.id, 30.5, device.auth_token) }

      it 'does edit the weight' do
        expect(json_response[:weight]).to eq 30.5
      end
      it 'does return ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'does return the pocket as specified in the serializer' do
        expect(json_response).to eq serializer.new(weighed_pocket.reload).as_json
      end
    end

    context 'when ApiKey is missing' do
      it 'does return invalid token' do
        put :edit_weight, params: { id: weighed_pocket.id, weight: 80.5 }
        expect(response).to have_http_status(401)
      end
    end

    context 'when pocket id is invalid' do
      it 'does return not found' do
        edit_weight_call(Pocket.pluck(:id).max + 1, 50.3, device.auth_token)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the weight is invalid or missing' do
      it 'does return bad request, negative weight' do
        edit_weight_call(weighed_pocket.id, -28.45, device.auth_token)
        expect(response).to have_http_status(400)
      end
      it 'does return bad request, empty weight' do
        edit_weight_call(weighed_pocket.id, '', device.auth_token)
        expect(response).to have_http_status(400)
      end
      it 'does return bad request, nil weight' do
        edit_weight_call(weighed_pocket.id, nil, device.auth_token)
        expect(response).to have_http_status(400)
      end
      it 'does return bad request, unweighed pocket' do
        edit_weight_call(unweighed_pocket.id, 80.8, device.auth_token)
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'PUT #add_weight' do
    let!(:unweighed_pocket) do
      create(:unweighed_pocket, organization: organization, collection: collection)
    end
    let!(:weighed_pocket) do
      create(:weighed_pocket, organization: organization, collection: collection)
    end
    let!(:device) do
      create(:device, device_id: '1', device_type: 'android', organization: organization)
    end
    let!(:weight) { Faker::Number.decimal(2, 2).to_f }

    def add_weight_call(pocket_id, weight)
      put :add_weight, params: { id: pocket_id, weight: weight }, as: :json
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when inputs are valid' do
        before(:each) { add_weight_call(unweighed_pocket.id, weight) }

        it 'does return ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'does add the weight' do
          expect(json_response[:weight]).to eq weight
        end

        it 'does change the state to Weighed' do
          expect(json_response[:state]).to eq 'Weighed'
        end

        it 'does return the pocket as specified in the serializer' do
          expect(json_response).to eq serializer.new(unweighed_pocket.reload).as_json
        end
      end

      context 'when pocket id is invalid' do
        it 'does return not found' do
          add_weight_call(Pocket.pluck(:id).max + 1, weight)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when the weight is invalid or missing' do
        it 'does return bad request, negative weight' do
          add_weight_call(unweighed_pocket.id, -14)
          expect(response).to have_http_status(400)
        end

        it 'does return bad request, empty weight' do
          add_weight_call(unweighed_pocket.id, '')
          expect(response).to have_http_status(400)
        end

        it 'does return bad request, nil weight' do
          add_weight_call(unweighed_pocket.id, nil)
          expect(response).to have_http_status(400)
        end

        it 'does return bad request, weighed pocket' do
          add_weight_call(weighed_pocket.id, weight)
          expect(response).to have_http_status(400)
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }

      before(:each) { add_weight_call(unweighed_pocket.id, weight) }

      it 'does return invalid token' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
