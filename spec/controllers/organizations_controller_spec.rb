require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let!(:organization) { FactoryBot.create(:organization) }
  let!(:user) { FactoryBot.create(:user, organization: organization) }
  let!(:device) { FactoryBot.create(:device, organization: organization, user: user) }

  describe 'POST#login' do
    context 'when credentials are validated' do
      it 'log in succesfully' do
        post :login, params: { name: organization.name, password: organization.password }
        @request.headers['device_id'] = device.device_id
        @request.headers['device_type'] = device.device_type
        expect(response).to have_http_status(:ok)
      end
      it 'returns an auth token' do
        post :login, params: { name: organization.name, password: organization.password }
        @request.headers['device_id'] = device.device_id
        @request.headers['device_type'] = device.device_type
        expect(response.headers['ApiKey']).not_to eq device.auth_token
      end
    end

    context 'when name is invalid' do
      it 'return invalid credentials' do
        post :login, params: { name: 'no organization', password: '123123' }
        @request.headers['Content-Type'] = 'application/pdf'
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when password is invalid' do
      it 'return invalid credentials' do
      end
    end
    context 'when at least, one header is missing' do
      it 'return error' do
        post :login, params: { name: organization.name, password: organization.password }
        @request.headers['device_id'] = device.device_id
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
