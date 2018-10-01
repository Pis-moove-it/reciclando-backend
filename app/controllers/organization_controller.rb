class OrganizationController < ApplicationController
  def testname
    authenticate(organization_by_name)
  end
  # private

  def organization_by_name
    @organization_by_name ||= Organization.find_by!(name: params['name'])
  end
end
