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
end
