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
    return render_error(1, 'Route already ended') if route.ended?
    return render_error(1, 'Missing or negative length') if check_invalid_length_entry
    return render_error(1, 'Missing points') if check_invalid_points_entry

    if route.update(length: params[:length])
      route_add_points
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
    query = Route.ended.where(date_query.merge(user_id: logged_user.organization.user_ids))
    paginated_render(query)
  end

  private

  def route
    @route ||= Route.find_by!(id: params[:id], user_id: [logged_user.organization.user_ids])
  end

  def route_params
    params.permit(:length)
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

  def route_add_points
    params['points'].map { |coord| Location.create(route_id: route.id, latitude: coord.first, longitude: coord.last) }
  end

  def check_invalid_length_entry
    route_params['length'].blank? || route_params['length'].to_f.negative?
  end

  def check_invalid_points_entry
    params['points'].nil? || params['points'].blank? || params['points'].length.zero?
  end
end
