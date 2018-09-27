class AuthController < BaseController
  def session
    return render_error(1, 'wrong credentials') unless check_credentials
    render json: device
  end

  private

  def device
    @device = Device.create_with(device_type: params[:device_type]).find_or_create_by(device_id: params[:device_id])
  end

  def check_credentials
    org = Organization.find_by(name: request.headers['name']).try(:authenticate, request.headers['password'])
    @check_credentials ||= org.is_a?(Organization)
  end
end
