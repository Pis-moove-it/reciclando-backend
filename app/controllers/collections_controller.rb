class CollectionsController < AuthenticateController
  skip_before_action :authenticated_user

  def create
    collection = Collection.new(collection_params.merge(pockets_attributes: pockets_with_organization,
                                                        route_id: params[:route_id]))
    if collection.save
      head :ok
    else
      render_error(1, collection.errors)
    end
  end

  private

  def pockets_with_organization
    collection_params[:pockets_attributes].collect { |pocket| pocket.merge(organization_id: Organization.first.id) }
  end

  def collection_params
    params.require(:collection).permit(:collection_point_id, pockets_attributes: [:serial_number])
  end
end
