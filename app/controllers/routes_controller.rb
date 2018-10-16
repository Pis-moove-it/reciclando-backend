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
    return render_error(1, 'Missing length') unless check_missing_entry('length')
    return render_error(1, 'Negative length') if negative_length?
    return render_error(1, 'Missing travel image') unless check_missing_entry('travel_image')

    return render_error(1, 'Route already ended') if route.ended?

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

  def negative_length?
    route_params[:length].negative?
  end

  def check_missing_entry(entry)
    route_params[entry].present?
  end

  def route_params
    params.permit(:length, :travel_image)
  end
end
