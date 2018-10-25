class CollectionPointsController < AuthenticateController
  def index
    render json: Container.available.where(organization_id: logged_user.organization.id)
  end
end
