class BalesController < AuthenticateController
  def index
    return render_error(1, 'Material must be Trash, Glass or Plastic.') unless valid_material?
    return render_error(1, 'Invalid dates') unless valid_dates?

    render json: Bale.where(bales_query.merge(organization: logged_user.organization)).order(:id)
  end

  def create
    bale = Bale.new(bale_params.merge(user: logged_user))
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
      render json: bale
    else
      render_error(1, bale.errors)
    end
  end

  private

  def bale
    @bale ||= Bale.find_by!(id: params[:id], organization: logged_user.organization)
  end

  def bale_params
    params.require(:bale).permit(:weight, :material)
  end

  # Method in charge of creating the optional query from query params (if present)
  #
  # Note: compact is used to remove nil values
  def bales_query
    material_query.merge(date_query).compact
  end

  def material_query
    { material: params[:material] }
  end

  def date_query
    return { created_at: params[:init_date]..params[:end_date] + ' 23:59:59' } if are_dates_present?
    {}
  end

  def valid_material?
    return %w[Trash Glass Plastic].include?(params[:material]) if params[:material].present?
    true
  end

  def valid_dates?
    return params[:init_date] <= params[:end_date] if are_dates_present?
    !(params[:init_date].present? || params[:end_date].present?)
  end

  def are_dates_present?
    params[:init_date].present? && params[:end_date].present?
  end
end
