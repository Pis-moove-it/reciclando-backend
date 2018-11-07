class EventsController < AuthenticateController
  def create
    return render_error(1, 'Missing pockets') if collection_params[:pockets_attributes].blank?
    collection = Collection.new(collection_params.merge(route_id: params[:route_id]))
    event = Event.new(event_params.merge(collections: [collection]))
    if event.save
      render json: event
    else
      render_error(1, event.errors)
    end
  end

  private

  def event_params
    params.require(:event).permit(:latitude, :longitude, :description)
  end

  def collection_params
    params.require(:collection).permit(pockets_attributes: [:serial_number])
  end
end
