class RoutesController < AuthenticateController
  def create
    route = Route.new(user: logged_user)
    if route.save
      render json: route
    else
      render_error(1, route.errors)
    end
  end
end
