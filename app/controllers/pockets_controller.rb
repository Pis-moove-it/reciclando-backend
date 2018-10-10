class PocketsController < AuthenticateController
  def index
    render json: Pocket.unclassified.where(organization_id: logged_user.organization.id)
  end

  def edit_serial_number
    pocket = Pocket.find(params[:id])
    return render_error(1, 'Missing serial number') if check_invalid_entry('serial_number')

    pocket.update!(serial_number: params['serial_number'])
    render json: pocket
  end

  def edit_weight
    pocket = Pocket.find(params[:id])
    return render_error(1, 'Missing weight') if check_invalid_entry('weight')
    return render_error(1, 'Unweighead pocket') if pocket.state == 'Unweighed'
    return render_error(1, 'Negative weight') if negative_weight?

    pocket.update!(weight: params['weight'])
    render json: pocket
  end

  def add_weight
    pocket = Pocket.find(params[:id])
    return render_error(1, 'Missing weight') if check_invalid_entry('weight')
    return render_error(1, 'Weighead pocket') if pocket.state == 'Weighed'
    return render_error(1, 'Negative weight') if negative_weight?

    pocket.update!(weight: params['weight'], state: 'Weighed')
    render json: pocket
  end

  private

  def check_invalid_entry(entry)
    params[entry].nil? || params[entry].blank?
  end

  def negative_weight?
    params[:weight].negative?
  end
end
