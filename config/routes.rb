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

  resources :pockets, only: [:index] do
    member do
      put :edit_serial_number
      put :edit_weight
      put :add_weight
    end
  end

  resources :routes, only: %i[create] do
    resources :collections, only: %i[create]
  end

  resources :bales, only: %i[index create show update] do
    collection do
      get :show_by_material
    end
  end

  resources :containers, only: %i[update]

  mount SwaggerUiEngine::Engine, at: '/api_docs'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
