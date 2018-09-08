Rails.application.routes.draw do
  get 'users/create'
  get 'users/destroy'
  get 'users/show'
  get 'users/update'
  mount SwaggerUiEngine::Engine, at: '/api_docs'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :organizations do
  #  resources :users
  end
  resources :users
end
