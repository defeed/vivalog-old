Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }
  resources :users do
    member do
      get :hourly_rate
      get :reset_password
      patch :toggle_active
    end
  end
  resources :projects do
    member do
      patch :finalize
    end
  end
  resources :entries, only: [:new, :create, :destroy]
  resource :dashboard, only: :index
  get :profile, to: 'users#show_profile'

  root 'dashboard#index'
end
