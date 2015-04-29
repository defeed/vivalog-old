Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }
  resources :users do
    member do
      get :reset_password
    end
  end
  resources :projects
  resources :entries, only: [:new, :create, :destroy]

  root 'projects#index'
end
