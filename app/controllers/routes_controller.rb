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
    byebug
    return render_error(1, 'Missing length') if route_params['length'].blank?
    #return render_error(1, 'Missing travel image') if route_params['travel_image'].blank?
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
    return render_error(1, 'Invalid dates') unless valid_dates?
    query = Route.where(date_query.merge(user_id: logged_user.organization.user_ids))
    paginated_render(query)
  end

  private

  def route
    @route ||= Route.find_by!(id: params[:id], user_id: [logged_user.organization.user_ids])
  end

  def route_params
    params.permit(:length) #, :locations)
  end

  def date_query
    return { created_at: params[:init_date]..params[:end_date] + ' 23:59:59' } if are_dates_present?
    {}
  end

  def valid_dates?
    return params[:init_date] <= params[:end_date] if are_dates_present?
    !(params[:init_date].present? || params[:end_date].present?)
  end

  def are_dates_present?
    params[:init_date].present? && params[:end_date].present?
  end
end
