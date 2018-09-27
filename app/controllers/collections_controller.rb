class CollectionsController < BaseController
  def create
    collection = Collection.new(collection_params)
    if collection.save
      head :ok
    else
      render_error(1, collection.errors)
    end
  end

  private

  def route
    @route ||= Route.find(params[:route_id])
  end

  def collection_params
    params.require(:collection).permit(:pocket_weight, :date, :collection_point_id)
  end
end
