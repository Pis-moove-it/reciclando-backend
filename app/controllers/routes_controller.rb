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

  def index
    query = Route.where(user_id: logged_user.organization.user_ids)
    paginated_render(query, params[:page], params[:per_page])
  end

  private

  def route
    @route ||= Route.find_by!(id: params[:id], user_id: [logged_user.organization.user_ids])
  end

  def route_params
    params.permit(:length, :travel_image)
  end
end
