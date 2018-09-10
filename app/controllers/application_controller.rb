class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end
end
