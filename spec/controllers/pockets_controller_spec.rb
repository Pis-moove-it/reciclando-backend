require 'rails_helper'

RSpec.describe PocketsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let!(:container) { create(:container, organization: organization) }
  let!(:collection) { create(:collection, route: route, collection_point: container) }
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
      let!(:container) { create(:container, organization: another_organization) }
      let!(:another_collection) do
        create(:collection, route: another_route, collection_point: container)
      end

      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      let!(:unclassified_pocket) do
        create(:unclassified_pocket, collection: collection)
      end
      let!(:classified_pocket) do
        create(:classified_pocket, collection: collection)
      end
      let!(:another_unclassified_pocket) do
        create(:unclassified_pocket, collection: another_collection)
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
    let!(:pocket) { create(:pocket, collection: collection) }

    def edit_serial_number_call(pocket_id, serial_number)
      put :edit_serial_number, params: { id: pocket_id, serial_number: serial_number }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when serial number is valid' do
        let(:new_serial_number) { Faker::Number.number(10) }
        before(:each) { edit_serial_number_call(pocket.id, new_serial_number) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the updated pocket' do
          pocket.reload
          expect(json_response).to eql serializer.new(pocket).as_json
        end

        it 'does update the serial number' do
          pocket.reload
          expect(pocket.serial_number).to eql new_serial_number
        end
      end

      context 'when serial number is invalid' do
        before(:each) { edit_serial_number_call(pocket.id, '') }

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when pocket does not exist' do
        let(:new_serial_number) { Faker::Number.number(10) }
        before(:each) { edit_serial_number_call(Pocket.pluck(:id).max + 1, new_serial_number) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end

      context 'when the pocket is from another organization' do
        let!(:another_organization) { create(:organization) }
        let!(:another_user) { create(:user, organization: another_organization) }
        let!(:another_route) { create(:route, user: another_user) }
        let!(:collection_point) { create(:collection_point) }
        let!(:another_collection) do
          create(:collection, route: another_route, collection_point: collection_point)
        end
        let!(:another_pocket) { create(:pocket, collection: another_collection) }

        let(:new_serial_number) { Faker::Number.number(10) }

        before(:each) { edit_serial_number_call(another_pocket.id, new_serial_number) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end
    end

    context 'when user is not authenticated' do
      let(:new_serial_number) { Faker::Number.number(10) }

      before(:each) { edit_serial_number_call(pocket.id, new_serial_number) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'PUT #edit_weight' do
    let!(:weighed_pocket) { create(:weighed_pocket, collection: collection) }
    let!(:unweighed_pocket) { create(:unweighed_pocket, collection: collection) }

    def edit_weight_call(pocket_id, weight)
      put :edit_weight, params: { id: pocket_id, weight: weight }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when weight is valid' do
        let(:new_weight) { Faker::Number.decimal(2, 2).to_f }
        before(:each) { edit_weight_call(weighed_pocket.id, new_weight) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the updated pocket' do
          weighed_pocket.reload
          expect(json_response).to eql serializer.new(weighed_pocket).as_json
        end

        it 'does update the weight' do
          weighed_pocket.reload
          expect(weighed_pocket.weight).to eql new_weight
        end
      end

      context 'when pocket is unweighed' do
        let(:new_weight) { Faker::Number.decimal(2, 2).to_f }
        before(:each) { edit_weight_call(unweighed_pocket.id, new_weight) }

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when weight is invalid' do
        before(:each) { edit_weight_call(weighed_pocket.id, '') }

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when pocket does not exist' do
        let(:new_weight) { Faker::Number.decimal(2, 2).to_f }
        before(:each) { edit_weight_call(Pocket.pluck(:id).max + 1, new_weight) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end

      context 'when the pocket is from another organization' do
        let!(:another_organization) { create(:organization) }
        let!(:another_user) { create(:user, organization: another_organization) }
        let!(:another_route) { create(:route, user: another_user) }
        let!(:collection_point) { create(:collection_point) }
        let!(:another_collection) do
          create(:collection, route: another_route, collection_point: collection_point)
        end
        let!(:another_pocket) { create(:pocket, collection: another_collection) }

        let(:new_weight) { Faker::Number.decimal(2, 2).to_f }

        before(:each) { edit_weight_call(another_pocket.id, new_weight) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end
    end

    context 'when user is not authenticated' do
      let(:new_weight) { Faker::Number.decimal(2, 2).to_f }

      before(:each) { edit_weight_call(weighed_pocket.id, new_weight) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'PUT #add_weight' do
    let!(:unweighed_pocket) { create(:unweighed_pocket, collection: collection) }
    let!(:weighed_pocket) { create(:weighed_pocket, collection: collection) }

    let!(:weight) { Faker::Number.decimal(2, 2).to_f }

    def add_weight_call(pocket_id, weight)
      put :add_weight, params: { id: pocket_id, weight: weight }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when inputs are valid' do
        before(:each) { add_weight_call(unweighed_pocket.id, weight) }

        it 'does return success' do
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
        before(:each) { add_weight_call(Pocket.pluck(:id).max + 1, weight) }

        it 'does return not found' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
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

      context 'when the pocket is from another organization' do
        let!(:another_organization) { create(:organization) }
        let!(:another_user) { create(:user, organization: another_organization) }
        let!(:another_route) { create(:route, user: another_user) }
        let!(:collection_point) { create(:collection_point) }
        let!(:another_collection) do
          create(:collection, route: another_route, collection_point: collection_point)
        end
        let!(:another_pocket) { create(:pocket, collection: another_collection) }

        let(:new_weight) { Faker::Number.decimal(2, 2).to_f }

        before(:each) { add_weight_call(another_pocket.id, new_weight) }

        it 'does return an error' do
          expect(response).to have_http_status(404)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }

      before(:each) { add_weight_call(unweighed_pocket.id, weight) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does return the specified error code' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
