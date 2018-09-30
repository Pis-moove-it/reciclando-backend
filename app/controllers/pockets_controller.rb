class PocketsController < AuthenticateController
  def index
    render json: Pocket.where(organization_id: logged_user.organization.id)
  end
end
