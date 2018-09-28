require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let!(:organization) { FactoryBot.create(:organization) }
  let!(:user) { FactoryBot.create(:user, organization: organization) }
  let!(:device) { FactoryBot.create(:device, organization: organization, user: user) }

  describe 'POST#session' do
    context 'when credentials are validated' do
      it 'returns an auth token' do
      end
    end
    context 'when name is invalid' do
      it 'return invalid credentials' do
        headers = {
          'name' => 'phoenix fundation',
          'password' => '123'
        }
        post '/authenticate', params: => { device_id: 'a33f', device_type: 'smartphone' } headers

        expect(response).to have_http_status(not_found)
      end
    end
    context 'when password is invalid' do
      it 'return invalid credentials' do
      end
    end
  end
end
