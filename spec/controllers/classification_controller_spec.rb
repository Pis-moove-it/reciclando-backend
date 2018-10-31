require 'rails_helper'
RSpec.describe ClassificationController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_keys: true) }

  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let!(:first_container) { create(:container, organization: organization) }
  let!(:second_container) { create(:container, organization: organization) }
  let!(:first_collection) { create(:collection, route: route, collection_point: first_container) }
  let!(:second_collection) { create(:collection, route: route, collection_point: second_container) }

  let!(:first_weighed_pocket) { create(:weighed_pocket, collection: first_collection) }
  let!(:second_weighed_pocket) { create(:weighed_pocket, collection: second_collection) }

  let!(:pockets) { [first_weighed_pocket, second_weighed_pocket] }

  let!(:p_serializer) { PocketSerializer }

  def serialize_pockets(pockets)
    pockets.collect { |p| p_serializer.new(p).as_json }
  end

  describe 'POST #create' do
    def classify_pockets_call(pocket_ids, kg_trash, kg_plastic, kg_glass)
      post :create, params: { pocket_ids: pocket_ids, kg_trash: kg_trash, kg_plastic: kg_plastic, kg_glass: kg_glass }
    end

    context 'when the user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when classificating correctly' do
        let!(:another_organization) { create(:organization) }
        let!(:another_user) { create(:user, organization: another_organization) }
        let!(:another_route) { create(:route, user: another_user) }
        let!(:another_container) { create(:container, organization: another_organization) }
        let!(:another_collection) { create(:collection, route: another_route, collection_point: another_container) }
        let!(:another_weighed_pocket) { create(:weighed_pocket, collection: another_collection) }

        let!(:kg_trash) { Faker::Number.decimal(2, 2).to_f }
        let!(:kg_plastic) { Faker::Number.decimal(2, 2).to_f }
        let!(:kg_glass) { Faker::Number.decimal(2, 2).to_f }

        before(:each) do
          classify_pockets_call(pockets.push(another_weighed_pocket).pluck(:id), kg_trash, kg_plastic, kg_glass)
        end

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return expected pockets as specified in serializer' do
          expect(json_response).to serialize_pockets(pockets)
        end

        it 'does return classified pockets' do
          expect(json_response.all?(&:Classified?)).to eql true
        end

        it 'does not classify pockets from another organization' do
          expect(another_weighed_pocket.state).not_to eql 'Classified'
        end
      end

      context 'when some pocket is unweighed' do
        let!(:unweighed_pocket) { create(:unweighed_pocket, collection: first_collection) }

        before(:each) do
          classify_pockets_call(pockets.push(unweighed_pocket).pluck(:id), kg_trash, kg_plastic, kg_glass)
        end

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when some pocket is classified' do
        let!(:classified_pocket) { create(:classified_pocket, collection: first_collection) }

        before(:each) do
          classify_pockets_call(pockets.push(classified_pocket).pluck(:id), kg_trash, kg_plastic, kg_glass)
        end

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when kg of trash is negative' do
        let!(:negative_kg_trash) { Faker::Number.negative }

        before(:each) { classify_pockets_call(pocket_ids, negative_kg_trash, kg_plastic, kg_glass) }

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when kg of plastic is negative' do
        let!(:negative_kg_plastic) { Faker::Number.negative }

        before(:each) { classify_pockets_call(pocket_ids, kg_trash, negative_kg_plastic, kg_glass) }

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when kg of glass is negative' do
        let!(:negative_kg_glass) { Faker::Number.negative }

        before(:each) { classify_pockets_call(pocket_ids, kg_trash, kg_plastic, negative_kg_glass) }

        it 'does return an error' do
          expect(response).to have_http_status(400)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 1
        end
      end
    end

    context 'when the user is not authenticated' do
      let!(:no_auth_user) { create(:user, organization: organization) }
      before(:each) { classify_pockets_call(pocket_ids, kg_trash, kg_plastic, kg_glass) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response['error_code']).to eql 2
      end
    end
  end
end
