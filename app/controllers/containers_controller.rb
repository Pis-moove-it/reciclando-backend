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

  def show
    render json: container, serializer: ContainerWebSerializer
  end

  private

  def container
    @container ||= Container.available.find_by!(id: params[:id], organization: logged_user.organization)
  end

  def container_params
    params.permit(:status)
  end
end
