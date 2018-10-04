class UsersController < AuthenticateController
  # TODO: Authenticate index and show methods.
  #       Note: To do that, remove the line below.
  skip_before_action :authenticated_user, except: [:login]

  def index
    render json: organization.users
  end

  def show
    render json: user
  end

  def login
    return render_error(1, logged_device.errors) unless logged_device.update(user: user)
    render json: user
  end

  private

  def user
    @user ||= User.find_by!(organization_id: params[:organization_id], id: params[:id])
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end
end
