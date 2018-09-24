class BalesController < BaseController
  def index
    render json: Bale.all
  end

  def create
    bale = Bale.new(bale_params)
    if bale.save
      render json: bale
    else
      render_error(1, bale.errors)
    end
  end

  def show
    render json: bale_by_id
  end

  def update
    if bale_by_id.update(bale_params)
      head :ok
    else
      render_error(1, bale_by_id.errors)
    end
  end

  private

  def bale_by_id
    @bale_by_id ||= Bale.find(params[:id])
  end

  def bale_params
    params.require(:bale).permit(:weight, :material)
  end
end
