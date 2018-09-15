require 'rails_helper'

RSpec.describe BalesController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_keys: true) }

  describe 'POST#create' do
    let!(:bale) { FactoryBot.create(:bale) }
    let(:b_serializer) { BaleSerializer }

    context 'Success case' do
      it 'should return success' do
        post :create, params: { bale: { weight: bale.weight, material: bale.material } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Failure cases' do
      it 'should not create a bale because it hasnt material' do
        post :create, params: { bale: { weight: bale.weight } }
        expect(response).to have_http_status(:bad_request)
      end

      it 'should not create a bale because it hasnt weight' do
        post :create, params: { bale: { material: bale.material } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET#index' do
    let!(:bale) { FactoryBot.create(:bale) }
    let(:b_serializer) { BaleSerializer }

    context 'Succes cases' do
      it 'should return succes' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'should return bales, as specified in the serializer' do
        get :index
        expect(json_response.first.keys).to eq %w[weight material]
      end
    end
  end

  describe 'GET#show' do
    let!(:bale) { FactoryBot.create(:bale) }
    let(:b_serializer) { BaleSerializer }

    context 'Succes cases' do
      it 'should return succes' do
        get :show, params: { id: bale.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Failure cases' do
      it 'should return not found' do
        get :show, params: { id: Bale.pluck(:id).max + 1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
