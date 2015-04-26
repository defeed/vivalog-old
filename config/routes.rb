Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_up: 'signup',
               sign_in: 'signin',
               sign_out: 'signout'
             }
  resources :projects
  resources :entries, only: [:new, :create, :destroy]

  root 'projects#index'
end
