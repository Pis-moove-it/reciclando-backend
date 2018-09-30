class AuthenticateController < BaseController
  before_action :authenticated_user

  private

  # This method verify if the user doing the request is authenticated.
  # If not, renders an Unauthorized error.
  #
  def authenticated_user
    return render_error(2, 'Invalid auth token') if logged_device.nil?
    logged_device
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
