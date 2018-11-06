class ApplicationController < ActionController::Base
  private

  def set_admin_timezone
    Time.zone = 'America/Montevideo'
  end
end
