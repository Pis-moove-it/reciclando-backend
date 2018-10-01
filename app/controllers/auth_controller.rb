class AuthController < BaseController
  def authenticate
    return render_error(1, 'wrong credentials') unless check_credentials
    response.set_header('access_token', device.auth_token)
    head :ok
  end

  private

  # logica de la organizacion <-
  def device
    # logica de este controlador
    @device = Device.create_with(device_type: @request_device_type).find_or_create_by(device_id: @request_device_id)
  end

  def check_credentials
    @check_credentials ||= Organization.find_by(name: params['name']).try(:authenticate, params['password'])
  end

  def request_device_type
    @request_device_type = request.headers['HTTP_DEVICE_TYPE']
  end

  def request_device_id
    @request_device_id = request.headers['HTTP_DEVICE_ID']
  end
  # organization <- viene
end
