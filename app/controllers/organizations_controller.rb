class OrganizationsController < AuthenticateController
  skip_before_action :authenticated_user, except: [:amount_recycled_by_month]

  def login
    return render_error(1, 'Wrong organization credentials') unless check_credentials

    return render_error(1, 'Cant create device for organization') unless authenticate_device_with(organization_by_name)

    render json: organization_by_name
  end

  def amount_recycled_by_month
    return render_error(1, 'Month is missing') if params['month'].blank?
    return render_error(1, 'Invalid month') unless (1..12).cover?(params['month'].to_i)

    amount_trash = 0
    amount_plastic = 0
    amount_glass = 0
    classified_pockets.each do |pocket|
      amount_trash += pocket.kg_trash
      amount_plastic += pocket.kg_recycled_plastic
      amount_glass += pocket.kg_recycled_glass
    end

    render json: {
      organization: organization_by_id.name,
      month: month_from_params,
      kg_trash: amount_trash, kg_plastic: amount_plastic, kg_glass: amount_glass
    }
  end

  private

  def organization_by_name
    @organization_by_name ||= Organization.find_by!(name: params['name'])
  end

  def organization_by_id
    @organization_by_id ||= Organization.find_by!(id: params['id'])
  end

  def check_credentials
    organization_by_name.authenticate(params['password'])
  end

  def classified_pockets
    @classified_pockets = organization_by_id.pockets.classified
                                            .monthly(month_from_params)
  end

  def month_from_params
    Date::MONTHNAMES[params['month'].to_i]
  end
end
