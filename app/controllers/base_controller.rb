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
    return render json: query unless page && per_page
    records = query.count
    response.headers['records'] = records
    set_total_pages(records, per_page)
    render json: query.page(page).per(per_page)
  end

  def set_total_pages(records, per_page)
    total_pages = 1
    total_pages = per_page.to_i % records if records > per_page.to_i
    response.headers['total_pages'] = total_pages
  end
end
