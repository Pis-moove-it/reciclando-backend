class BaseController < ApplicationController
  protect_from_forgery with: :null_session

  rescue_from StandardError do |exception|
    render_error(4, exception)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error(3, exception)
  end

  private

  def render_error(error_code, error_details = '')
    render json: Error.error_for(error_code, error_details),
           status: Error.status_for(error_code)
  end

  def paginated_render(query, page, per_page)
    count = query.count
    page_count = (count / per_page.to_f).ceil
    response.headers['total'] = page_count
    response.headers['records'] = count
    render json: query.page(page).per(per_page)
  end
end
