class AuthenticateController < BaseController
  before_action :authenticated_user

  def authenticate_device_with(organization)
    return false unless (device = device_for(organization))
    response.set_header('ApiKey', device.auth_token)
  end

  private

  # This method verify if the user doing the request is authenticated.
  # If not, renders an Unauthorized error.
  #
  def authenticated_user
    return render_error(2, 'Invalid auth token') if logged_device.nil?
    logged_device
  end

  # Search for device with device_id
  #   If it is not found, we create a new one
  #   If there is one, we updated it
  #
  def create_or_update_device(organization)
    if (device = Device.find_by(device_id: device_id))
      device.update!(organization: organization)
      device
    else
      Device.create!(device_id: device_id, device_type: device_type,
                     organization: organization)
    end
  end

  def device_for(organization)
    return nil unless device_type && device_id && (device = create_or_update_device(organization))
    device
  end

  def device_type
    return false if request.headers['DeviceTypeHeader'].blank?
    request.headers['DeviceTypeHeader']
  end

  def device_id
    return false if request.headers['DeviceTypeHeader'].blank?
    request.headers['DeviceIdHeader']
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
