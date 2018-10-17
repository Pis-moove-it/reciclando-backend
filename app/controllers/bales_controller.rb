class BalesController < AuthenticateController
  def index
    render json: Bale.where(organization: logged_user.organization).page(2).per(3)
    #render json: Bale.where(organization: logged_user.organization)
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
    return render_error(1, 'Material must be: "Trash", "Glass" or "Plastic".') unless check_entry

    render json: Bale.where(organization: logged_user.organization,
                            material: params[:material])
  end

  def show_by_date
    return render_error(1, 'Initial date missing') if missing_entry('init_date')
    return render_error(1, 'End date missing') if missing_entry('end_date')
    return render_error(1, 'The initial date is after the end date') unless check_date

    render json: Bale.where(organization: logged_user.organization,
                            created_at: params[:init_date]..params[:end_date] + ' 23:59:59')
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
    /\A(Glass|Plastic|Trash)\z/.match(params[:material])
  end

  def check_date
    params[:init_date] <= params[:end_date]
  end

  def missing_entry(entry)
    params[entry].nil? || params[entry].blank?
  end
end
