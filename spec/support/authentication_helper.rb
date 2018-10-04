# Helper module regarding authentication
#
module AuthenticationHelper
  def create_an_authenticated_user_with(organization, device_id, device_type)
    user = FactoryBot.create(:user, organization: organization)
    device = FactoryBot.create(:device, device_id: device_id,
                                        device_type: device_type,
                                        user: user, organization: organization)
    @request.headers['ApiKey'] = device.auth_token
    user
  end
end
