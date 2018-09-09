Rails.application.routes.draw do
  resources :organizations do
    resources :users
  end
  mount SwaggerUiEngine::Engine, at: '/api_docs'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
