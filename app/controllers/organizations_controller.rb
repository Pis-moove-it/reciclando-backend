class OrganizationsController < ApplicationController
  def create
    organization = Organization.new(organization_params)
    if organization.save
      # organization created succesfully, return new instance
      render json: organization
    else
      # organization failed to create, return bad_request
      render json: organization.errors, status: :bad_request
    end
  end

  def show
    render json: organization_by_id
  end

  def destroy
    # organization destroyed succesfully
    organization_by_id.destroy
    head :ok
  end

  def list_users
    render json: Organization.find(params[:organization_id]).users
  end

  def update
    if organization_by_id.update(organization_params)
      head :ok
    else
      render json: organization.errors, status: :bad_request
    end
  end

  private

  def organization_by_id
    # variable loaded once
    @organization_by_id ||= Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
