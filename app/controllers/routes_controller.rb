class RoutesController < AuthenticateController
  def create
    route = Route.new(user_id: logged_user.id)
    if route.save
      render json: route
    else
      render_error(1, route.errors)
    end
  end
end
