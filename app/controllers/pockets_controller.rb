class PocketsController < AuthenticateController
  def index
    render json: Pocket.unclassified.where(organization_id: logged_user.organization.id)
  end

  def edit_serial_number
    return render_error(1, 'Missing serial number') if params[:serial_number].blank?

    if pocket.update(edit_serial_number_params)
      render json: pocket
    else
      render_error(1, pocket.errors)
    end
  end

  def edit_weight
    return render_error(1, 'Missing weight') if params[:weight].blank?
    return render_error(1, 'Unweighead pocket') if pocket.Unweighed?

    if pocket.update(weight_params)
      render json: pocket
    else
      render_error(1, pocket.errors)
    end
  end

  def add_weight
    return render_error(1, 'Missing weight') if params[:weight].blank?
    return render_error(1, 'Weighead pocket') if pocket.Weighed?

    if pocket.update(weight_params.merge(state: 'Weighed'))
      render json: pocket
    else
      render_error(1, pocket.errors)
    end
  end

  private

  def pocket
    @pocket ||= Pocket.find_by!(id: params[:id], organization: logged_user.organization)
  end

  def edit_serial_number_params
    params.permit(:serial_number)
  end

  def weight_params
    params.permit(:weight)
  end
end
