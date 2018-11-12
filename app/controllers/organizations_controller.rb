class OrganizationsController < AuthenticateController
  skip_before_action :authenticated_user

  def login
    return render_error(1, 'Wrong organization credentials') unless check_credentials

    return render_error(1, 'Cant create device for organization') unless authenticate_device_with(organization_by_name)

    render json: organization_by_name
  end

  def amount_recycled_by_month
    amount_trash = 0
    amount_plastic = 0
    amount_glass = 0
    classified_pockets.each do |p|
      amount_trash += p.kg_trash
      amount_plastic += p.kg_recycled_plastic
      amount_glass += p.kg_recycled_glass
    end
    render json: { organization: organization_by_id.name, month: Date::MONTHNAMES[params['month']],
                   kg_trash: amount_trash, kg_plastic: amount_plastic, kg_glass: amount_glass }
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
    @pockets = organization_by_id.pockets.where(state: 'Classified', created_at:
      Date::MONTHNAMES[params['month']].to_time(:utc).beginning_of_month..
      Date::MONTHNAMES[params['month']].to_time(:utc).end_of_month)
  end
end
