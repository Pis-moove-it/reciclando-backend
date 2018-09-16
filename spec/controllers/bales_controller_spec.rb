require 'rails_helper'

RSpec.describe BalesController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_keys: true) }
  let!(:bale) { FactoryBot.create(:bale) }
  let(:b_serializer) { BaleSerializer }

  describe 'POST#create' do
    def create_bale_call(weight, material)
      post :create, params: { bale: { weight: weight, material: material } }
    end

    context 'Success case' do
      it 'should return success' do
        create_bale_call(bale.weight, bale.material)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Failure cases' do
      it 'should not create a bale because it hasnt material' do
        create_bale_call(bale.weight, nil)
        expect(response).to have_http_status(:bad_request)
      end

      it 'should not create a bale because it hasnt weight' do
        create_bale_call(bale.material, nil)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET#index' do
    before(:each) { get :index }
    context 'Succes cases' do
      it 'should return succes' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return bales, as specified in the serializer' do
        expect(json_response.first.keys).to eq %w[id weight material]
      end
    end
  end

  describe 'GET#show' do
    def bale_by_id_call(id)
      get :show, params: { id: id }
    end
    context 'Succes cases' do
      it 'should return succes' do
        bale_by_id_call(bale.id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Failure cases' do
      it 'should return not found' do
        bale_by_id_call(Bale.pluck(:id).max + 1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
