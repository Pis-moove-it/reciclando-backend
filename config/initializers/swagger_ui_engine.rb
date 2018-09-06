SwaggerUiEngine.configure do |config|
  config.admin_username = ENV['ADMIN_USERNAME'] || 'reciclando'
  config.admin_password = ENV['ADMIN_PASSWORD'] || 'reciclando'
  config.swagger_url = '/api/swagger.yaml'
  config.doc_expansion = 'list'
  config.request_headers = 'true'
end
