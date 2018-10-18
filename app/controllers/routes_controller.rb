class RoutesController < AuthenticateController
  before_action :validate_ended_route, only: [:update]

  def create
    route = Route.new(user: logged_user)
    if route.save
      render json: route
    else
      render_error(1, route.errors)
    end
  end

  def update
    if route.update(route_params)
      render json: route
    else
      render_error(1, route.errors)
    end
  end

  private

  def route
    @route ||= Route.find(params[:id])
  end

  def validate_ended_route
    return render_error(1, 'Missing length') if route_params['length'].blank?
    return render_error(1, 'Negative length') if route_params['length'].negative?
    return render_error(1, 'Missing travel image') if route_params['travel_image'].blank?
    return render_error(1, 'Route already ended') if route.ended?
  end

  def route_params
    params.permit(:length, :travel_image)
  end
end
