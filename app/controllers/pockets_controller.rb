class PocketsController < AuthenticateController
  def index
    render json: Pocket.unclassified.where(organization_id: logged_user.organization.id)
  end
end
