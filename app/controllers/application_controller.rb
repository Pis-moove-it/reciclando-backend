class ApplicationController < ActionController::Base
  private

  def set_admin_timezone
    Time.zone = 'America/Montevideo'
  end

  def set_admin_locale
    I18n.locale = :es
  end
end
