class PocketsController < AuthenticateController
  def index
    render json: Pocket.unclassified.where(organization_id: logged_user.organization.id)
  end

  def edit_serial_number
    return render_error(1, 'Missing serial number') if params[:serial_number].blank?

    if pocket.update(serial_number: params[:serial_number])
      render json: pocket
    else
      render_error(1, pocket.errors)
    end
  end

  def edit_weight
    return render_error(1, 'Missing weight') if params[:weight].blank?
    return render_error(1, 'Unweighead pocket') if pocket.Unweighed?
    return render_error(1, 'Negative weight') if params[:weight].negative?

    if pocket.update(weight: params[:weight])
      render json: pocket
    else
      render_error(1, pocket.errors)
    end
  end

  def add_weight
    return render_error(1, 'Missing weight') if params[:weight].blank?
    return render_error(1, 'Weighead pocket') if pocket.Weighed?
    return render_error(1, 'Negative weight') if params[:weight].negative?

    if pocket.update(weight: params[:weight], state: 'Weighed')
      render json: pocket
    else
      render_error(1, pocket.errors)
    end
  end

  private

  def pocket
    @pocket ||= Pocket.find_by!(id: params[:id], organization: logged_user.organization)
  end
end
