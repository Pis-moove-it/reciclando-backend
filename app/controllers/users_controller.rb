class UsersController < BaseController
  def index
    render json: organization.users
  end

  def show
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
