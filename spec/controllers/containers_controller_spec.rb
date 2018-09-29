require 'rails_helper'

RSpec.describe ContainersController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_keys: true) }
  let!(:container) { FactoryBot.create(:container) }
  let!(:updated_container) { FactoryBot.build(:container) }
  let(:invalid_id) { Container.pluck(:id).max + 1 }

  describe 'PUT #update' do
    def update_container_call(id, status)
      put :update, params: { id: id, container: { status: status } }
    end

    context 'when updating valid containers' do
      it 'does return success' do
        update_container_call(container.id, updated_container.status)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when updating non-existent containers' do
      it 'does return not found' do
        update_container_call(invalid_id, updated_container.status)
        expect(json_response['error_code']).to eq 3
      end
    end

    context 'when updating containers with wrong values' do
      it 'does return bad request, nil status value' do
        update_container_call(container.id, nil)
        expect(json_response['error_code']).to eq 1
      end
      it 'does return internal error, invalid status value' do
        update_container_call(container.id, 'invalid_value')
        expect(json_response['error_code']).to eq 4
      end
    end
  end
end
