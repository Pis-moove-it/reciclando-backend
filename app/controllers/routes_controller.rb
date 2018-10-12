class RoutesController < AuthenticateController
  def create
    route = Route.new(user: logged_user)
    if route.save
      render json: route
    else
      render_error(1, route.errors)
    end
  end

  def update
    return render_error(1, 'Missing length') if route_params['length'].blank?
    return render_error(1, 'Negative length') if route_params['length'].negative?
    return render_error(1, 'Missing travel image') if route_params['travel_image'].blank?
    return render_error(1, 'Route already ended') if route.ended?

    if route.update(route_params)
      render json: route
    else
      render_error(1, route.errors)
    end
  end

  def show
    render json: route
  end

  private

  def route
    @route ||= Route.find(params[:id])
  end

  def route_params
    params.permit(:length, :travel_image)
  end
end
