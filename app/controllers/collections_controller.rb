class CollectionsController < AuthenticateController
  def create
    return render_error(1, 'Missing pockets') if collection_params[:pockets_attributes].blank?
    collection = Collection.new(collection_params.merge(route_id: params[:route_id]))
    if collection.save
      render json: collection
    else
      render_error(1, collection.errors)
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:collection_point_id, pockets_attributes: [:serial_number])
  end
end
