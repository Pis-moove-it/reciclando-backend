class BalesController < AuthenticateController
  def index
    render json: Bale.where(organization: logged_user.organization)
  end

  def create
    bale = Bale.new(bale_params.merge(organization: logged_user.organization, user: logged_user))
    if bale.save
      render json: bale
    else
      render_error(1, bale.errors)
    end
  end

  def show
    render json: bale
  end

  def show_by_material
    return render_error(1, 'Invalid material.') if check_entry
    render json: Bale.where(material: request.headers['material'])
  end

  def update
    if bale.update(bale_params)
      render json: bale
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

  def check_entry
    /\A(Glass|Plastic|Trash)\z/.match(request.headers['material'])
  end
end
