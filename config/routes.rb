Rails.application.routes.draw do
  resources :organizations, only: [] do
    collection do
      post :login
    end
    resources :users, only: %i[index show] do
      member do
        post :login
      end
    end
  end

  resources :pockets, only: [:index]

  resources :bales, only: %i[index create show update]

  resources :containers, only: %i[update]

  mount SwaggerUiEngine::Engine, at: '/api_docs'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
