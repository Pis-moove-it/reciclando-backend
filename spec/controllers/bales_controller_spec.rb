require 'rails_helper'

RSpec.describe BalesController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_keys: true) }
  let!(:bale) { FactoryBot.create(:bale) }
  let!(:updated_bale) { FactoryBot.build(:bale) }
  let(:b_serializer) { BaleSerializer }
  let(:invalid_id) { Bale.pluck(:id).max + 1 }

  describe 'POST #create' do
    def create_bale_call(weight, material)
      post :create, params: { bale: { weight: weight, material: material } }
    end

    context 'when creating valid bales' do
      it 'does return success' do
        create_bale_call(bale.weight, bale.material)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when creating invalid bales' do
      it 'does not create bales without material' do
        create_bale_call(bale.weight, nil)
        expect(response).to have_http_status(:bad_request)
      end
      it 'does not create bales without weight' do
        create_bale_call(bale.weight, nil)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET #index' do
    before(:each) { get :index }

    context 'when listing bales' do
      it 'does return succes' do
        expect(response).to have_http_status(:ok)
      end
      it 'does return bales as specified in the serializer' do
        expect(json_response.first.keys).to eq %w[id weight material]
      end
    end
  end

  describe 'GET #show' do
    def bale_by_id_call(id)
      get :show, params: { id: id }
    end

    context 'when shows valid bales' do
      it 'does return succes' do
        bale_by_id_call(bale.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when shows invalid bales' do
      it 'does return not found' do
        bale_by_id_call(invalid_id)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #update' do
    def update_bale_call(id, weight, material)
      put :update, params: { id: id, bale: { weight: weight, material: material } }
    end

    context 'when updating valid bales' do
      it 'does return success' do
        update_bale_call(bale.id, updated_bale.weight, updated_bale.material)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when creating invalid bales' do
      it 'does return not found' do
        update_bale_call(invalid_id, updated_bale.weight, updated_bale.material)
        expect(json_response['error_code']).to eq 3
      end

      it 'does not update a bale because it has empty attributes' do
        update_bale_call(bale.id, nil, nil)
        expect(json_response['error_code']).to eq 1
      end
    end
  end
end
