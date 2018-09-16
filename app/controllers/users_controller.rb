class UsersController < BaseController
  def index
    render json: organization.users
  end

  def show
    render json: user_by_id
  end

  private

  def user_by_id
    @user_by_id ||= organization.users.find(params[:id])
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end
end
