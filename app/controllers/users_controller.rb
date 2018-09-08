class UsersController < ApplicationController
  def index
    render json: User.all
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors, status: :bad_request
    end
  end

  def show
    render json: user_by_id
  end

  def destroy
    user_by_id.destroy
    head :ok
  end

  def update
    if user_by_id.update(user_params)
      head :ok
    else
      render json: user.errors, status: :bad_request
    end
  end

  private

  def user_by_id
    # variable loaded once
    @user_by_id ||= User.find(params[:ci])
  end

  def user_params
    params.require(:user).permit(:ci, :name, :surname, :email, :organization_id)
  end
end
