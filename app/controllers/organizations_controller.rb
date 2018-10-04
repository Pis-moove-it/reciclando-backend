class OrganizationsController < AuthenticateController
  skip_before_action :authenticated_user

  def login
    return render_error(1, 'Wrong organization credentials') unless check_credentials

    return render_error(1, 'Cant create device for organization') unless authenticate_device_with(organization_by_name)

    render json: organization_by_name
  end

  private

  def organization_by_name
    @organization_by_name ||= Organization.find_by!(name: params['name'])
  end

  def check_credentials
    organization_by_name.authenticate(params['password'])
  end
end
