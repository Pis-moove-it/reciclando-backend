class ContainersController < BaseController
  def update
    if container.update(container_params)
      head :ok
    else
      render_error(1, container.errors)
    end
  end

  private

  def container
    @container ||= Container.find(params[:id])
  end

  def container_params
    params.require(:container).permit(:status, :active)
  end
end
