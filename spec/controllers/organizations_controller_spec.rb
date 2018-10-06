require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:serializer) { OrganizationSerializer }

  let!(:organization) { create(:organization) }

  describe 'POST #login' do
    def organization_login_call(device_id, device_type, name, password)
      @request.headers['DeviceIdHeader'] = device_id
      @request.headers['DeviceTypeHeader'] = device_type
      post :login, params: { name: name, password: password }
    end

    context 'when using valid organization credentials' do
      before(:each) { organization_login_call('1', 'android', organization.name, 'password') }

      it 'does return success' do
        expect(response).to have_http_status(:ok)
      end

      it 'does create a device' do
        expect(Device.count).to eql 1
      end

      it 'does create a device with device id and type' do
        expect(Device.first.device_id).to eql '1'
        expect(Device.first.device_type).to eql 'android'
      end

      it 'does return auth token from the created device' do
        expect(response.headers['ApiKey']).not_to eql nil
        expect(response.headers['ApiKey']).to eql Device.first.auth_token
      end

      it 'does return the logged organization' do
        expect(json_response).to eql serializer.new(organization).as_json
      end
    end

    context 'when using a non existent organization name' do
      before(:each) { organization_login_call('1', 'android', 'Invalid', 'password') }

      it 'does return an error' do
        expect(response).to have_http_status(404)
      end

      it 'does return an error' do
        expect(json_response[:error_code]).to eql 3
      end

      it 'does not create a device' do
        expect(Device.count).to eql 0
      end

      it 'does not return auth token' do
        expect(response.headers['ApiKey']).to eql nil
      end
    end

    context 'when using wrong password' do
      before(:each) { organization_login_call('1', 'android', organization.name, 'wrongPass') }

      it 'does return an error' do
        expect(response).to have_http_status(400)
      end

      it 'does return an error' do
        expect(json_response[:error_code]).to eql 1
      end

      it 'does not create a device' do
        expect(Device.count).to eql 0
      end

      it 'does not return auth token' do
        expect(response.headers['ApiKey']).to eql nil
      end
    end

    context 'when at least, one header is missing' do
      after(:each) do
        expect(response).to have_http_status(400)
        expect(json_response[:error_code]).to eql 1

        expect(Device.count).to eql 0
        expect(response.headers['ApiKey']).to eql nil
      end

      it 'does return error when device id is missing' do
        organization_login_call(nil, 'android', organization.name, 'wrongPass')
      end

      it 'does return error when device type is missing' do
        organization_login_call('1', nil, organization.name, 'wrongPass')
      end
    end

    context 'when the device already exists' do
      let!(:another_organization) { create(:organization) }
      let!(:user) { create(:user, organization: organization) }
      let!(:device) do
        create(:device, device_id: '1', device_type: 'android',
                        organization: another_organization)
      end
      before(:each) { organization_login_call('1', 'android', organization.name, 'password') }

      it 'should return success' do
        expect(response).to have_http_status(:ok)
      end

      it 'does not create a new device' do
        expect(Device.count).to eql 1
      end

      it 'does update the device organization' do
        expect(Device.first.organization.id).not_to eql another_organization.id
        expect(Device.first.organization.id).to eql organization.id
      end

      it 'does return auth token from the created device' do
        expect(response.headers['ApiKey']).not_to eql nil
        expect(response.headers['ApiKey']).to eql Device.first.auth_token
      end

      it 'does return the logged organization' do
        expect(json_response).to eql serializer.new(organization).as_json
      end
    end
  end
end
