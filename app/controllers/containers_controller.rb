class ContainersController < AuthenticateController
  def index
    query = Container.available.where(organization_id: logged_user.organization.id)
    paginated_render(query)
  end

  def update
    if container.update(container_params)
      render json: container
    else
      render_error(1, container.errors)
    end
  end

  private

  def container
    @container ||= Container.find(params[:id])
  end

  def container_params
    params.permit(:status)
  end
end
