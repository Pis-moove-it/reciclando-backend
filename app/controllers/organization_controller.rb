class OrganizationController < AuthenticateController
  skip_before_action :authenticated_user

  def login
    return render_error(1, 'wrong credentials') unless check_credentials_of(organization_by_name)
    authenticate_device_with(organization)
    render json: organization_by_name
  end

  private

  def organization_by_name
    @organization_by_name ||= Organization.find_by!(name: params['name'])
  end

  def check_credentials_of(organization)
    organization.authenticate(params['password'])
  end
end
