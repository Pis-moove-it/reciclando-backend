require 'yaml'

module Error
  extend self

  def status_for(code)
    errors[code]['http_status']
  end

  def error_for(code, details)
    error = errors[code]
    error['details'] = details if details.present?
    error
  end

  private

  def errors
    return @errors unless @errors.nil?
    @errors = YAML.load_file(Rails.root.join('lib', 'support', 'errors.yaml'))
  end
end
