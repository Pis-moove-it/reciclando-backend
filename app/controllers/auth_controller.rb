class AuthController < BaseController

  def session
    if check_credentials
      render json: { 'token' => device.auth_token }
    else
      render_error(1, 'wrong credentials')
    end
  end

  private

  def device
    @device = Device.create_with(device_type: params[:device_type]).find_or_create_by(device_id: params[:device_id])
  end

  def check_credentials
    @check_credentials = Organization.find_by(name: request.header['name']).try(:authenticate, request.header['password'])
  end
end
