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
    render json: bale
  end

  def update
    if bale.update(bale_params)
      head :ok
    else
      render_error(1, bale.errors)
    end
  end

  private

  def bale
    @bale ||= Bale.find(params[:id])
  end

  def bale_params
    params.require(:bale).permit(:weight, :material)
  end
end
