class AuthenticateController < BaseController
  before_action :authenticated_user

  # authenticate OR create a device
  def authenticate_device_with(organization)
    device = device_for(organization)
    response.set_header('ApiKey', device.auth_token) if device
  end

  private

  # This method verify if the user doing the request is authenticated.
  # If not, renders an Unauthorized error.

  def authenticated_user
    return render_error(2, 'Invalid auth token') if logged_device.nil?
    logged_device
  end

  def create_device(organization)
    Device.transaction do
      device = Device.create_with(device_type: device_type).find_or_create_by!(device_id: device_id)
      device.update!(organization: organization)
    end
  end

  def device_for(organization)
    return nil unless device_type && device_id && (device = create_device(organization))
    device
  end

  def device_type
    request.headers['HTTP_DEVICE_TYPE']
  end

  def device_id
    request.headers['HTTP_DEVICE_ID']
  end

  def logged_device
    @logged_device ||= Device.where(auth_token: auth_token).first
  end

  def logged_user
    @logged_user ||= logged_device.user
  end

  def auth_token
    request.headers['ApiKey']
  end
end
