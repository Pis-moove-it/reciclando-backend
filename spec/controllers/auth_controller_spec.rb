require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let!(:organization) { FactoryBot.create(:organization) }
  let!(:user) { FactoryBot.create(:user, organization: organization) }
  let!(:device) { FactoryBot.create(:device, organization: organization, user: user) }

  describe 'POST#session' do
    context 'when credentials are validated' do
      it 'log in succesfully' do
        post :authenticate, params: { name: organization.name, password: organization.password }
        @request.headers['device_id'] = device.device_id
        @request.headers['device_type'] = device.device_type
        expect(response).to have_http_status(:ok)
      end
      it 'returns an auth token' do
        post :authenticate, params: { name: organization.name, password: organization.password }
        @request.headers['device_id'] = device.device_id
        @request.headers['device_type'] = device.device_type
        expect(response.headers['access_token']).not_to eq device.auth_token
      end
    end

    context 'when name is invalid' do
      it 'return invalid credentials' do
        post :authenticate, params: { name: 'no organization', password: '123123' }
        @request.headers['Content-Type'] = 'application/pdf'
        expect(response).to have_http_status(:bad_request)
      end
    end
    context 'when password is invalid' do
      it 'return invalid credentials' do
      end
    end
  end
end
