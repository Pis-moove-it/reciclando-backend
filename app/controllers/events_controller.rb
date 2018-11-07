class EventsController < AuthenticateController
  skip_before_action :authenticated_user

  def create
    event = Event.new(event_params)
    collection = Collection.new(collection_params.merge(route_id: params[:route_id], collection_point: event))
    if collection.save
      render json: event
    else
      render_error(1, collection.errors)
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
