require 'rails_helper'

RSpec.describe PocketsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  let!(:organization) { create(:organization) }
  let(:serializer) { PocketSerializer }

  describe 'GET #index' do
    def list_pockets_call
      get :index
    end

    context 'when the user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:pocket) { create(:pocket, organization: organization) }

      let!(:another_organization) { create(:organization) }
      let!(:another_pocket) { create(:pocket, organization: another_organization) }

      before(:each) { list_pockets_call }

      it 'does return success' do
        expect(response).to have_http_status(200)
      end

      it 'does return all the pockets' do
        expect(json_response).to eql [serializer.new(pocket).as_json]
      end

      it 'does not return the pockets from another organization' do
        expect(json_response.pluck(:id)).not_to include another_pocket.id
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
end
