require 'rails_helper'

RSpec.describe ContainersController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET #index' do
    let!(:organization) { create(:organization) }
    let(:c_serializer) { ContainerSerializer }

    def serialize_containers(containers)
      containers.collect { |c| c_serializer.new(c).as_json }
    end

    context 'when user is authenticated' do
      let(:another_organization) { create(:organization) }

      let!(:ok_container) { FactoryBot.create(:ok_container, organization: organization) }
      let!(:damaged_container) { FactoryBot.create(:damaged_container, organization: organization) }
      let!(:removed_container) { FactoryBot.create(:removed_container, organization: organization) }
      let!(:inactive_container) { FactoryBot.create(:inactive_container, organization: organization) }
      let!(:another_container) { FactoryBot.create(:container, organization: another_organization, status: 'Ok') }

      let!(:organization_containers) { [ok_container, damaged_container] }

      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      before(:each) { get :index }

      it 'does return success' do
        expect(response).to have_http_status(:ok)
      end

      it 'does return only the organization containers' do
        expect(json_response).to eql serialize_containers(organization_containers)
      end

      it 'does not return containers from another organization' do
        expect(json_response.pluck(:id)).not_to include(another_container.id)
      end

      it 'does not return removed containers' do
        expect(json_response.pluck(:id)).not_to include(removed_container.id)
      end

      it 'does not return inactive containers' do
        expect(json_response.pluck(:id)).not_to include(inactive_container.id)
      end

      context 'when listing paged containers' do
        before(:each) { get :index, params: { per_page: 2 } }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return containers as specified in the serializer' do
          expect(json_response).to eql serialize_containers(organization_containers)
        end
      end
    end

    context 'when the user is not authenticated' do
      before(:each) { get :index }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'PUT #update' do
    let!(:organization) { create(:organization) }
    let!(:container) { FactoryBot.create(:available_container, organization: organization) }
    let(:invalid_id) { Container.pluck(:id).max + 1 }
    let(:serializer) { ContainerSerializer }

    def update_container_call(id, status)
      put :update, params: { id: id, status: status }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

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

      context 'when updating removed containers' do
        let!(:removed_container) { create(:removed_container, organization: organization) }

        it 'does return not found' do
          update_container_call(removed_container.id, %w[Ok Damaged Removed].sample)
          expect(response).to have_http_status(404)
          expect(json_response[:error_code]).to eq 3
        end
      end

      context 'when updating inactive containers' do
        let!(:inactive_container) { create(:inactive_container, organization: organization) }

        it 'does return not found' do
          update_container_call(inactive_container.id, %w[Ok Damaged Removed].sample)
          expect(response).to have_http_status(404)
          expect(json_response[:error_code]).to eq 3
        end
      end

      context 'when updating containers from another organization' do
        let!(:another_organization) { create(:organization) }
        let!(:another_container) { create(:available_container, organization: another_organization) }

        it 'does return not found' do
          update_container_call(another_container.id, %w[Ok Damaged Removed].sample)
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

    context 'when the user is not authenticated' do
      before(:each) { update_container_call(container.id, %w[Ok Damaged Removed].sample) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'GET #show' do
    let!(:organization) { create(:organization) }

    def container_by_id_call(container_id)
      get :show, params: { id: container_id }
    end

    let(:web_serializer) { ContainerWebSerializer }

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when showing a available container' do
        let!(:container) { create(:available_container, organization: organization) }

        before(:each) { container_by_id_call(container.id) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the serialized container' do
          expect(json_response).to eql web_serializer.new(container).as_json
        end
      end

      context 'when searching for removed containers' do
        let!(:container) { create(:removed_container, organization: organization) }
        before(:each) { container_by_id_call(container.id) }

        it 'does return an error' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end

      context 'when searching for inactive containers' do
        let!(:container) { create(:inactive_container, organization: organization) }
        before(:each) { container_by_id_call(container.id) }

        it 'does return an error' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end

      context 'when searching for unexistent containers' do
        before(:each) { container_by_id_call(1) }

        it 'does return an error' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end

      context 'when searching for containers from another organization' do
        let!(:another_organization) { create(:organization) }
        let!(:another_container) { create(:available_container, organization: another_organization) }

        before(:each) { container_by_id_call(another_container.id) }

        it 'does return an error' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:container) { create(:container, organization: organization) }

      before(:each) { container_by_id_call(container.id) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
