class CollectionPointsController < BaseController
  # FIXME: Find the way to authenticate this endpoints or at least
  # be sure that the requests are coming from the CMS map
  #
  # Note: This methods are used to create/update/destroy
  #       collection points from the CMS map

  def create
    CollectionPoint.create(collection_params)
  end

  def update
    collection_point.update(update_collection_params)
  end

  def destroy
    collection_point.destroy
  end

  private

  def collection_point
    @collection_point ||= CollectionPoint.find_by(latitude: params[:latitude], longitude: params[:longitude])
  end

  def collection_params
    params.permit(:latitude, :longitude, :type, :status, :organization_id)
  end

  def update_collection_params
    params.permit(:active)
  end
end
