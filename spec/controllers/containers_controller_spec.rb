require 'rails_helper'

RSpec.describe ContainersController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'PUT #update' do
    let!(:container) { FactoryBot.create(:container) }
    let(:invalid_id) { Container.pluck(:id).max + 1 }
    let(:serializer) { ContainerSerializer }

    def update_container_call(id, status)
      put :update, params: { id: id, status: status }
    end

    context 'when updating valid containers' do
      before(:each) { update_container_call(container.id, %w[Ok Damaged Removed].sample) }

      it 'does return success' do
        expect(response).to have_http_status(:ok)
      end
      it 'does return the container as specified in the serializer' do
        expect(json_response).to eq serializer.new(container.reload).as_json
      end
    end

    context 'when updating non-existent containers' do
      it 'does return not found' do
        update_container_call(invalid_id, %w[Ok Damaged Removed].sample)
        expect(response).to have_http_status(404)
        expect(json_response[:error_code]).to eq 3
      end
    end

    context 'when updating containers with wrong values' do
      it 'does return bad request, nil status value' do
        update_container_call(container.id, nil)
        expect(response).to have_http_status(400)
        expect(json_response[:error_code]).to eq 1
      end
      it 'does return internal error, invalid status value' do
        update_container_call(container.id, 'invalid_value')
        expect(response).to have_http_status(500)
        expect(json_response[:error_code]).to eq 4
      end
    end
  end
end
