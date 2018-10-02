class CollectionsController < AuthenticateController
  def create
    collection = Collection.new(collection_params.except(:pocket_serial_numbers).merge(route: route))
    serials = params[:collection][:pocket_serial_numbers]
    pockets = serials.collect { |s| { serial_number: s, organization: logged_user.organization } }
    collection.pockets.new(pockets)
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
    params.require(:collection).permit(:collection_point_id, :pocket_serial_numbers)
  end
end
